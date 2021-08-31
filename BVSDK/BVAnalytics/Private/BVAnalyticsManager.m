//
//  BVAnalyticsManager.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <sys/utsname.h>

#import "BVAnalyticEventManager+Private.h"
#import "BVAnalyticsManager+Testing.h"
#import "BVAnalyticsRemoteLogger.h"
#import "BVLocaleServiceManager.h"
#import "BVLogger+Private.h"
#import "BVNetworkingManager.h"
#import "BVNullHelper.h"
#import "BVPersonalizationEvent.h"
#import "BVSDKConfiguration.h"
#import "BVSDKConstants.h"
#import "BVSDKManager+Private.h"
#import "BVUserAgent+NSURLRequest.h"

@interface BVAnalyticsManager ()

@property(nonatomic, strong)
    NSMutableArray *eventQueue; /// Impressions, other non-pageview events
@property(nonatomic, strong) NSMutableArray *pageviewQueue; /// Page views
@property(nonatomic, strong) dispatch_queue_t concurrentEventQueue;

@property(nonatomic, strong) dispatch_source_t queueFlushTimer;
@property(nonatomic, assign, readwrite) NSTimeInterval queueFlushInterval;
@property(nonatomic, strong) dispatch_queue_t timerEventQueue;

@property(nonatomic, strong)
    dispatch_queue_t localeUpdateNotificationTokenQueue;
@property(nonatomic, strong) id<NSObject> localeUpdateNotificationCenterToken;

/// Testing
@property(nonatomic, strong, readonly)
    NSMutableDictionary<NSString *, dispatch_block_t>
        *testImpressionEventCompletionQueue;
@property(nonatomic, strong, readonly)
    NSMutableDictionary<NSString *, dispatch_block_t>
        *testPageViewEventCompletionQueue;

@end

@implementation BVAnalyticsManager

@synthesize analyticsLocale = _analyticsLocale,
            testImpressionEventCompletionQueue =
                _testImpressionEventCompletionQueue,
            testPageViewEventCompletionQueue =
                _testPageViewEventCompletionQueue;

#pragma mark - Class Methods

static BVAnalyticsManager *analyticsInstance = nil;
+ (BVAnalyticsManager *)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    analyticsInstance = [[self alloc] init];
  });

  return analyticsInstance;
}

#pragma mark - Class Properties

- (void)setFlushInterval:(NSTimeInterval)newFlushInterval {
  dispatch_sync(self.timerEventQueue, ^{
    self.queueFlushInterval = newFlushInterval;
  });
}

- (NSMutableDictionary<NSString *, dispatch_block_t> *)
    testImpressionEventCompletionQueue {
  if (!_testImpressionEventCompletionQueue) {
    _testImpressionEventCompletionQueue = [NSMutableDictionary dictionary];
  }

  return _testImpressionEventCompletionQueue;
}

- (NSMutableDictionary<NSString *, dispatch_block_t> *)
    testPageViewEventCompletionQueue {
  if (!_testPageViewEventCompletionQueue) {
    _testPageViewEventCompletionQueue = [NSMutableDictionary dictionary];
  }

  return _testPageViewEventCompletionQueue;
}

#pragma mark - Class Init

- (id)init {
  if ((self = [super init])) {
    self.eventQueue = [NSMutableArray array];
    self.pageviewQueue = [NSMutableArray array];
    self.concurrentEventQueue = dispatch_queue_create(
        "com.bazaarvoice.analyticEventQueue", DISPATCH_QUEUE_CONCURRENT);
    self.timerEventQueue = dispatch_queue_create(
        "com.bazaarvoice.timerEventQueue", DISPATCH_QUEUE_SERIAL);
    self.localeUpdateNotificationTokenQueue = dispatch_queue_create(
        "com.bazaarvoice.notificationTokenQueue", DISPATCH_QUEUE_SERIAL);

    [self setFlushInterval:10.0f];
    [self registerForAppStateChanges];

    /// Kick Remote Logging Facility
    (void)[BVAnalyticsRemoteLogger sharedRemoteLogger];
  }
  return self;
}

#pragma mark - Analytics Constant Parameters

- (NSMutableDictionary *)getMobileDiagnosticParams {
  // get diagnostic data
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

  NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
  NSString *osVersion = [[UIDevice currentDevice] systemVersion];
  NSString *majorMinor =
      [infoDictionary objectForKey:@"CFBundleShortVersionString"];
  NSString *build =
      [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
  NSString *appVersion =
      [NSString stringWithFormat:@"%@.%@", majorMinor, build];

  struct utsname systemInfo;
  uname(&systemInfo);
  NSString *platform = [NSString stringWithCString:systemInfo.machine
                                          encoding:NSUTF8StringEncoding];

  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setValue:bundleIdentifier forKey:@"mobileAppIdentifier"];
  [params setValue:appVersion forKey:@"mobileAppVersion"];
  [params setValue:osVersion forKey:@"mobileOSVersion"];
  [params setValue:@"ios-objc" forKey:@"mobileOS"];
  [params setValue:platform forKey:@"mobileDeviceName"];
  [params setValue:BV_SDK_VERSION forKey:@"bvSDKVersion"];

  return params;
}

#pragma mark - Application state change updates

- (void)registerForAppStateChanges {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [self setUpApplicationDidFinishLaunching];
    [self setUpApplicationDidBecomeActive];
    [self setUpApplicationDidEnterBackground];
  });
}

- (void)setUpApplicationDidFinishLaunching {
  [[NSNotificationCenter defaultCenter]
      addObserverForName:UIApplicationDidFinishLaunchingNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *note) {
                [self sendAppLaunchedEvent:note.userInfo];
              }];
}

- (void)setUpApplicationDidBecomeActive {
  [[NSNotificationCenter defaultCenter]
      addObserverForName:UIApplicationDidBecomeActiveNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *note) {
                [self sendAppActiveEvent:note.userInfo];
              }];
}

- (void)setUpApplicationDidEnterBackground {
  [[NSNotificationCenter defaultCenter]
      addObserverForName:UIApplicationDidEnterBackgroundNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *note) {
                [self sendAppInBackgroundEvent:note.userInfo];
              }];
}

#pragma mark - App lifecycle events

- (NSDictionary *)getAppStateEventParams {
  return @{
    @"cl" : @"Lifecycle",
    @"type" : @"MobileApp",
    @"source" : @"mobile-lifecycle"
  };
}

- (void)sendAppLaunchedEvent:(NSDictionary *)userInfo {
  NSDictionary *additionalContext = @{@"appSubState" : @"user-initiated"};

  if (userInfo) {
    do {
      if ([userInfo objectForKey:UIApplicationLaunchOptionsURLKey]) {
        additionalContext = @{@"appSubState" : @"url-initiated"};
        break;
      }

      if ([userInfo
              objectForKey:UIApplicationLaunchOptionsSourceApplicationKey]) {
        additionalContext = @{@"appSubState" : @"other-app-initiated"};
        break;
      }

      if ([userInfo
              objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        additionalContext =
            @{@"appSubState" : @"remote-notification-initiated"};
        break;
      }

      if ([userInfo
              objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]) {
        additionalContext = @{@"appSubState" : @"local-notification-initiated"};
        break;
      }

    } while (NO);
  }

  [self sendAppStateEvent:@"launched" appSubState:additionalContext];
}

- (void)sendAppActiveEvent:(NSDictionary *)userInfo {
  [self sendAppStateEvent:@"active"];
}

- (void)sendAppInBackgroundEvent:(NSDictionary *)userInfo {
  [self sendAppStateEvent:@"background"];
}

- (void)sendAppStateEvent:(NSString *)appState {
  [self sendAppStateEvent:appState appSubState:nil];
}

- (void)sendAppStateEvent:(NSString *)appState
              appSubState:(NSDictionary *)additionalContext {
  // build param dictionary

  NSMutableDictionary *eventData = [NSMutableDictionary
      dictionaryWithDictionary:[[BVAnalyticEventManager sharedManager]
                                   getCommonAnalyticsDict]];
  [eventData addEntriesFromDictionary:[self getMobileDiagnosticParams]];
  [eventData addEntriesFromDictionary:[self getAppStateEventParams]];
  [eventData setObject:appState forKey:@"appState"];

  if (additionalContext) {
    [eventData addEntriesFromDictionary:additionalContext];
  }

  // send request
  [self queueEvent:eventData];
}

#pragma mark - Event Timer

- (void)setTimer {
  dispatch_sync(self.timerEventQueue, ^{
    if (nil == self.queueFlushTimer) {
      self.queueFlushTimer = dispatch_source_create(
          DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.concurrentEventQueue);

      NSAssert(self.queueFlushTimer,
               @"dispatch_source_t timer wasn't allocated properly.");

      if (self.queueFlushTimer) {
        dispatch_source_set_timer(
            self.queueFlushTimer,
            dispatch_time(DISPATCH_TIME_NOW,
                          self.queueFlushInterval * NSEC_PER_SEC),
            DISPATCH_TIME_FOREVER, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.queueFlushTimer, ^{
          [self flushQueue];
        });
        dispatch_resume(self.queueFlushTimer);
      }
    }
  });
}

- (void)invalidateTimer {
  dispatch_sync(self.timerEventQueue, ^{
    if (nil != self.queueFlushTimer) {
      dispatch_source_cancel(self.queueFlushTimer);
      self.queueFlushTimer = nil;
    }
  });
}

#pragma mark - Event Queueing

- (void)queueEvent:(NSDictionary *)eventData {
  BVLogAnalytics(([NSString stringWithFormat:@"%@ - %@ - %@",
                                             [eventData objectForKey:@"cl"],
                                             [eventData objectForKey:@"type"],
                                             [eventData objectForKey:@"name"]]),
                 BV_PRODUCT_ANALYTICS);
  [self processEvent:eventData ];
}

- (void)processEvent:(NSDictionary *)eventData {
  NSMutableDictionary *eventForQueue =
      [NSMutableDictionary dictionaryWithDictionary:eventData];
  [eventForQueue
      addEntriesFromDictionary:[[BVAnalyticEventManager sharedManager]
                                   getCommonAnalyticsDict]];

  dispatch_barrier_sync(self.concurrentEventQueue, ^{
    // Update event queue
    [self.eventQueue addObject:eventForQueue];
  });

  [self scheduleEventQueueFlush];
}

- (void)scheduleEventQueueFlush {
  // schedule a queue flush, if not already scheduled
  // many times, a rush of events come very close to each other, and then
  // things are quiet for a while.

  dispatch_async(self.concurrentEventQueue, ^{
    [self setTimer];
  });
}

- (void)queuePageViewEventDict:(NSDictionary *)pageViewEvent {
  NSMutableDictionary *eventForQueue =
      [NSMutableDictionary dictionaryWithDictionary:pageViewEvent];
  [eventForQueue
      addEntriesFromDictionary:[[BVAnalyticEventManager sharedManager]
                                   getCommonAnalyticsDict]];

  dispatch_barrier_sync(self.concurrentEventQueue, ^{
    // Update PageView queue events
    [self.pageviewQueue addObject:eventForQueue];
  });

  [self flushQueue];
}

- (void)flushQueue {
  dispatch_barrier_async(self.concurrentEventQueue, ^{
    [self flushQueueUnsafe];
  });
}

// Flush queue for POST batch
- (void)flushQueueUnsafe {
  // clear flush timer
  [self invalidateTimer];

  // send events
  if ([self.eventQueue count] > 0) {
    NSDictionary *batch = @{@"batch" : self.eventQueue};
    [self sendBatchedPOSTEvent:batch
         withCompletionHandler:^(NSError *__nullable error) {
           if (error) {
             BVLogError(
                 ([NSString stringWithFormat:
                                @"ERROR: posting magpie impression event%@",
                                error.localizedDescription]),
                 BV_PRODUCT_ANALYTICS);
           }

           [self flushImpressionEventCompletionQueue];

         }];

    // purge queue
    [self.eventQueue removeAllObjects];
  }

  // send page view events
  if ([self.pageviewQueue count] > 0) {
    NSDictionary *batch = @{@"batch" : self.pageviewQueue};
    [self sendBatchedPOSTEvent:batch
         withCompletionHandler:^(NSError *__nullable error) {
           if (error) {
             BVLogError(
                 ([NSString
                     stringWithFormat:@"ERROR: posting magpie pageview event%@",
                                      error.localizedDescription]),
                 BV_PRODUCT_ANALYTICS);
           }

           [self flushPageViewEventCompletionQueue];

         }];

    // purge pageview queue
    [self.pageviewQueue removeAllObjects];
  }
}

- (void)sendBatchedPOSTEvent:(NSDictionary *)eventData
       withCompletionHandler:
           (void (^)(NSError *__nullable error))completionHandler {
  NSURL *url = [NSURL URLWithString:[self baseUrl]];
  BVLogAnalytics(([NSString stringWithFormat:@"POST Event: %@\nWith Data:%@",
                                             url, eventData]),
                 BV_PRODUCT_ANALYTICS);

  if (_isDryRunAnalytics) {
    BVLogInfo(@"Analytic events are not being sent to server",
              BV_PRODUCT_ANALYTICS);
    return;
  }

  /// For private classes we ask for the NSURLSession but we don't hand back
  /// any objects since it would be useless to the developers as they have no
  /// interface to the object graph.
  NSURLSession *session = nil;
  id<BVURLSessionDelegate> sessionDelegate =
      [BVSDKManager sharedManager].urlSessionDelegate;
  if (sessionDelegate &&
      [sessionDelegate respondsToSelector:@selector(URLSessionForBVObject:)]) {
    session = [sessionDelegate URLSessionForBVObject:nil];
  }

  session = session ?: [BVNetworkingManager sharedManager].bvNetworkingSession;

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"POST";
  [request setValue:@"application/json"
      forHTTPHeaderField:@"Content-Type"]; // content type
  [request setValue:[NSURLRequest
                       bvUserAgentWithLocaleIdentifier:self.analyticsLocale.localeIdentifier]
      forHTTPHeaderField:@"User-Agent"];
  NSError *error = nil;
  NSData *data = [NSJSONSerialization dataWithJSONObject:eventData
                                                 options:kNilOptions
                                                   error:&error];

  if (!error) {
    NSURLSessionUploadTask *postTask = [session
        uploadTaskWithRequest:request
                     fromData:data
            completionHandler:^(NSData *data, NSURLResponse *response,
                                NSError *error) {

              // completion
              // one-way communication, client->server: disregard results
              // but log error, if any
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
              if ((httpResponse && httpResponse.statusCode >= 300) || error) {
                if (data) {
                  NSString *errorMsg =
                      [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
                  BVLogError(errorMsg, BV_PRODUCT_ANALYTICS);

                } else {
                  BVLogError(
                      ([NSString stringWithFormat:@"ERROR: Posting "
                                                  @"analytics event "
                                                  @"failed with "
                                                  @"status: %ld and "
                                                  @"error: %@",
                                                  (long)httpResponse.statusCode,
                                                  error]),
                      BV_PRODUCT_ANALYTICS);
                }

              } else {
                // Successful analyatics event sent
                NSString *message = [NSString
                    stringWithFormat:@"Analytics event sent successfully."];
                BVLogAnalytics(message, BV_PRODUCT_ANALYTICS);
              }

              dispatch_barrier_async(self.concurrentEventQueue, ^{
                completionHandler(error);
              });

            }];

    [postTask resume];
  };
}

#pragma mark - NSLocale Analytic Handling

- (NSLocale *)analyticsLocale {
  __block NSLocale *locale = nil;
  dispatch_sync(self.localeUpdateNotificationTokenQueue, ^{
    locale = self->_analyticsLocale;
  });
  return locale;
}

- (void)setAnalyticsLocale:(NSLocale *)analyticsLocale {
  dispatch_sync(self.localeUpdateNotificationTokenQueue, ^{
    self->_analyticsLocale = analyticsLocale;

    if (self->_analyticsLocale) {
      /// Turn off locale state changes
      [self unregisterForCurrentLocaleDidChangeNotifications];
    } else {
      self->_analyticsLocale = [NSLocale autoupdatingCurrentLocale];
      /// Turn on locale state changes
      [self registerForCurrentLocaleDidChangeNotifications];
    }

    [self logAnalyticsLocaleUnsafe];
  });
}

- (void)logAnalyticsLocale {
  dispatch_sync(self.localeUpdateNotificationTokenQueue, ^{
    [self logAnalyticsLocaleUnsafe];
  });
}

- (void)logAnalyticsLocaleUnsafe {
  NSString *logLocale = nil;
  if (_analyticsLocale) {
    logLocale =
        ((NSString *)[_analyticsLocale objectForKey:NSLocaleCountryCode])
            .uppercaseString;
  }

  BVLogAnalytics(
      ([NSString
          stringWithFormat:@"Configuration has set Locale: %@", logLocale]),
      BV_PRODUCT_ANALYTICS);
}

- (void)registerForCurrentLocaleDidChangeNotifications {
  if (!self.localeUpdateNotificationCenterToken) {
    BVLogAnalytics(@"Analytics REGISTERING for Locale Change Notifications.",
                   BV_PRODUCT_ANALYTICS);

    self.localeUpdateNotificationCenterToken =
        [[NSNotificationCenter defaultCenter]
            addObserverForName:NSCurrentLocaleDidChangeNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *note) {
                      dispatch_sync(self.localeUpdateNotificationTokenQueue, ^{
                        self->_analyticsLocale =
                            [NSLocale autoupdatingCurrentLocale];
                        [self logAnalyticsLocaleUnsafe];
                      });
                    }];
  }
}

- (void)unregisterForCurrentLocaleDidChangeNotifications {
  BVLogAnalytics(@"Analytics UNREGISTERING for Locale Change Notifications.",
                 BV_PRODUCT_ANALYTICS);

  if (self.localeUpdateNotificationCenterToken) {
    [[NSNotificationCenter defaultCenter]
        removeObserver:self.localeUpdateNotificationCenterToken];
    self.localeUpdateNotificationCenterToken = nil;
  }
}

#pragma mark - Helpers

- (NSString *)formatDate:(NSDate *)date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  NSLocale *enUSPOSIXLocale =
      [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
  [dateFormatter setLocale:enUSPOSIXLocale];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];

  return [dateFormatter
      stringFromDate:date]; // return ISO-8601 formatted UTC timestamp
}

- (nonnull NSString *)baseUrl {
  BVLocaleServiceManager *localeServiceManager =
      [BVLocaleServiceManager sharedManager];
  NSAssert(localeServiceManager, @"BVLocaleServiceManager is nil.");

  if (self.isStagingServer) {
    BVLogError(@"WARNING: Using staging server for analytic events. This "
               @"should only be enabled for non-production.",
               BV_PRODUCT_ANALYTICS);
  }

  return [localeServiceManager
      resourceForService:BVLocaleServiceManagerServiceAnalytics
              withLocale:self.analyticsLocale
         andIsProduction:(!self.isStagingServer)];
}

#pragma mark - Testing

- (void)enqueueImpressionTestWithName:(NSString *)testName
                  withCompletionBlock:(dispatch_block_t)completionBlock {
  dispatch_barrier_sync(self.concurrentEventQueue, ^{

    dispatch_block_t opaqueCompletion =
        self.testImpressionEventCompletionQueue[testName];
    if (opaqueCompletion) {
      opaqueCompletion();
    }

    self.testImpressionEventCompletionQueue[testName] = completionBlock;

    NSAssert(
        2 > self.testImpressionEventCompletionQueue.allKeys.count,
        @"Attempting to run more than one test, probably a race condition.");
  });
}

- (void)enqueuePageViewTestWithName:(NSString *)testName
                withCompletionBlock:(dispatch_block_t)completionBlock {
  dispatch_barrier_sync(self.concurrentEventQueue, ^{

    dispatch_block_t opaqueCompletion =
        self.testPageViewEventCompletionQueue[testName];
    if (opaqueCompletion) {
      opaqueCompletion();
    }

    self.testPageViewEventCompletionQueue[testName] = completionBlock;

    NSAssert(
        2 > self.testPageViewEventCompletionQueue.allKeys.count,
        @"Attempting to run more than one test, probably a race condition.");
  });
}

- (void)flushImpressionEventCompletionQueue {
  dispatch_barrier_async(self.concurrentEventQueue, ^{

    if (!self->_testImpressionEventCompletionQueue) {
      return;
    }

    dispatch_block_t opaqueCompletion =
        self.testImpressionEventCompletionQueue.allValues.firstObject;
    if (opaqueCompletion) {
      opaqueCompletion();
    }

    [self.testImpressionEventCompletionQueue removeAllObjects];
  });
}

- (void)flushPageViewEventCompletionQueue {
  dispatch_barrier_async(self.concurrentEventQueue, ^{

    if (!self->_testPageViewEventCompletionQueue) {
      return;
    }

    dispatch_block_t opaqueCompletion =
        self.testPageViewEventCompletionQueue.allValues.firstObject;
    if (opaqueCompletion) {
      opaqueCompletion();
    }

    [self.testPageViewEventCompletionQueue removeAllObjects];
  });
}

@end
