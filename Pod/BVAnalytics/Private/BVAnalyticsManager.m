//
//  BVAnalyticsManager.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>

#import "BVAnalyticEventManager.h"
#import "BVAnalyticsManager.h"
#import "BVLocaleServiceManager.h"
#import "BVLogger.h"
#import "BVPersonalizationEvent.h"
#import "BVSDKConfiguration.h"
#import "BVSDKConstants.h"
#import "BVSDKManager.h"

#include <sys/sysctl.h>
#include <sys/utsname.h>

@interface BVAnalyticsManager ()

@property(strong)
    NSMutableArray *eventQueue; // Impressions, other non-pageview events
@property(strong) NSMutableArray *pageviewQueue; // Page views
@property NSTimer *queueFlushTimer;
@property NSTimeInterval queueFlushInterval;

@property(nonatomic, strong)
    dispatch_queue_t localeUpdateNotificationTokenQueue;
@property(strong) id<NSObject> localeUpdateNotificationCenterToken;

@property(nonatomic, strong) dispatch_queue_t concurrentEventQueue;

@end

@implementation BVAnalyticsManager

@synthesize analyticsLocale = _analyticsLocale;

static BVAnalyticsManager *analyticsInstance = nil;

+ (BVAnalyticsManager *)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    analyticsInstance = [[self alloc] init];
  });

  return analyticsInstance;
}

- (id)init {
  self = [super init];
  if (self != nil) {
    self.eventQueue = [NSMutableArray array];
    self.pageviewQueue = [NSMutableArray array];
    self.concurrentEventQueue = dispatch_queue_create(
        "com.bazaarvoice.analyticEventQueue", DISPATCH_QUEUE_CONCURRENT);
    self.localeUpdateNotificationTokenQueue = dispatch_queue_create(
        "com.bazaarvoice.notificationTokenQueue", DISPATCH_QUEUE_SERIAL);

    [self setFlushInterval:10.0];
    [self registerForAppStateChanges];
  }
  return self;
}

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
  [params setValue:@"ios" forKey:@"mobileOS"];
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
                                   getCommonAnalyticsDictAnonymous:NO]];
  [eventData addEntriesFromDictionary:[self getMobileDiagnosticParams]];
  [eventData addEntriesFromDictionary:[self getAppStateEventParams]];
  [eventData setObject:appState forKey:@"appState"];

  if (additionalContext) {
    [eventData addEntriesFromDictionary:additionalContext];
  }

  // send request
  [self queueEvent:eventData];
}

#pragma mark - Event Queueing

- (void)queueEvent:(NSDictionary *)eventData {
  [[BVLogger sharedLogger]
      analyticsMessage:[NSString
                           stringWithFormat:@"%@ - %@ - %@",
                                            [eventData objectForKey:@"cl"],
                                            [eventData objectForKey:@"type"],
                                            [eventData objectForKey:@"name"]]];
  [self processEvent:eventData isAnonymous:NO];
}

- (void)queueAnonymousEvent:(NSDictionary *)eventData {
  [self processEvent:eventData isAnonymous:YES];
}

- (void)processEvent:(NSDictionary *)eventData isAnonymous:(BOOL)anonymous {
  NSMutableDictionary *eventForQueue =
      [NSMutableDictionary dictionaryWithDictionary:eventData];
  [eventForQueue
      addEntriesFromDictionary:[[BVAnalyticEventManager sharedManager]
                                   getCommonAnalyticsDictAnonymous:anonymous]];

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

  dispatch_async(dispatch_get_main_queue(), ^{

    if (self.queueFlushTimer == nil) {
      SEL flushQueueSelector = @selector(flushQueue);

      self.queueFlushTimer =
          [NSTimer scheduledTimerWithTimeInterval:self.queueFlushInterval
                                           target:self
                                         selector:flushQueueSelector
                                         userInfo:nil
                                          repeats:NO];
    }
  });
}

- (void)queuePageViewEventDict:(NSDictionary *)pageViewEvent {
  NSMutableDictionary *eventForQueue =
      [NSMutableDictionary dictionaryWithDictionary:pageViewEvent];
  [eventForQueue
      addEntriesFromDictionary:[[BVAnalyticEventManager sharedManager]
                                   getCommonAnalyticsDictAnonymous:NO]];

  dispatch_barrier_sync(self.concurrentEventQueue, ^{
    // Update PageView queue events
    [self.pageviewQueue addObject:eventForQueue];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self flushQueue];
    });
  });
}

// Flush queue for POST batch
- (void)flushQueue {
  // clear flush timer
  if (self.queueFlushTimer != nil) {
    [self.queueFlushTimer invalidate];
  }
  self.queueFlushTimer = nil;

  // send events
  if ([self.eventQueue count] > 0) {
    NSDictionary *batch = @{@"batch" : self.eventQueue};
    [self
         sendBatchedPOSTEvent:batch
        withCompletionHandler:^(NSError *__nullable error) {
          if (error) {
            [[BVLogger sharedLogger]
                error:[NSString stringWithFormat:
                                    @"ERROR: posting magpie impression event%@",
                                    error.localizedDescription]];
          }

          // For internal testing
          dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
                postNotificationName:@"BV_INTERNAL_MAGPIE_EVENT_COMPLETED"
                              object:error];
          });

        }];

    dispatch_barrier_sync(self.concurrentEventQueue, ^{
      // purge queue
      [self.eventQueue removeAllObjects];
    });
  }

  // send page view events
  if ([self.pageviewQueue count] > 0) {
    NSDictionary *batch = @{@"batch" : self.pageviewQueue};
    [self
         sendBatchedPOSTEvent:batch
        withCompletionHandler:^(NSError *__nullable error) {
          if (error) {
            [[BVLogger sharedLogger]
                error:[NSString stringWithFormat:
                                    @"ERROR: posting magpie pageview event%@",
                                    error.localizedDescription]];
          }

          // For internal testing
          dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
                postNotificationName:@"BV_INTERNAL_PAGEVIEW_ANALYTICS_COMPLETED"
                              object:error];
          });

        }];

    dispatch_barrier_sync(self.concurrentEventQueue, ^{
      // purge pageview queue
      [self.pageviewQueue removeAllObjects];
    });
  }
}

- (void)sendBatchedPOSTEvent:(NSDictionary *)eventData
       withCompletionHandler:
           (void (^)(NSError *__nullable error))completionHandler {
  NSURL *url = [NSURL URLWithString:[self baseUrl]];
  [[BVLogger sharedLogger]
      analyticsMessage:[NSString
                           stringWithFormat:@"POST Event: %@\nWith Data:%@",
                                            url, eventData]];

  if (_isDryRunAnalytics) {
    [[BVLogger sharedLogger]
        info:@"Analytic events are not being sent to server"];
    return;
  }

  NSURLSessionConfiguration *config =
      [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"POST";
  [request setValue:@"application/json"
      forHTTPHeaderField:@"Content-Type"]; // content type

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
              if ((httpResponse && httpResponse.statusCode >= 300) ||
                  error != nil) {
                if (data) {
                  NSString *errorMsg =
                      [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
                  [[BVLogger sharedLogger] error:errorMsg];

                } else {
                  [[BVLogger sharedLogger]
                      error:[NSString
                                stringWithFormat:@"ERROR: Posting "
                                                 @"analytics event "
                                                 @"failed with "
                                                 @"status: %ld and "
                                                 @"error: %@",
                                                 (long)httpResponse.statusCode,
                                                 error]];
                }

              } else {
                // Successful analyatics event sent
                NSString *message = [NSString
                    stringWithFormat:@"Analytics event sent successfully."];
                [[BVLogger sharedLogger] analyticsMessage:message];
              }

              completionHandler(error);

            }];

    [postTask resume];
  };
}

#pragma mark - NSLocale Analytic Handling

- (NSLocale *)analyticsLocale {
  __block NSLocale *locale = nil;
  dispatch_sync(self.localeUpdateNotificationTokenQueue, ^{
    locale = _analyticsLocale;
  });
  return locale;
}

- (void)setAnalyticsLocale:(NSLocale *)analyticsLocale {
  dispatch_sync(self.localeUpdateNotificationTokenQueue, ^{
    _analyticsLocale = analyticsLocale;

    if (_analyticsLocale) {
      /// Turn off locale state changes
      [self unregisterForCurrentLocaleDidChangeNotifications];
    } else {
      _analyticsLocale = [NSLocale autoupdatingCurrentLocale];
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

  [[BVLogger sharedLogger]
      analyticsMessage:[NSString
                           stringWithFormat:@"Configuration has set Locale: %@",
                                            logLocale]];
}

- (void)registerForCurrentLocaleDidChangeNotifications {
  if (!self.localeUpdateNotificationCenterToken) {
    [[BVLogger sharedLogger]
        analyticsMessage:
            @"Analytics REGISTERING for Locale Change Notifications."];

    self.localeUpdateNotificationCenterToken =
        [[NSNotificationCenter defaultCenter]
            addObserverForName:NSCurrentLocaleDidChangeNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *note) {
                      dispatch_sync(self.localeUpdateNotificationTokenQueue, ^{
                        _analyticsLocale = [NSLocale autoupdatingCurrentLocale];
                        [self logAnalyticsLocaleUnsafe];
                      });
                    }];
  }
}

- (void)unregisterForCurrentLocaleDidChangeNotifications {

  [[BVLogger sharedLogger]
      analyticsMessage:
          @"Analytics UNREGISTERING for Locale Change Notifications."];

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

- (NSString *)baseUrl {
  BVLocaleServiceManager *localeServiceManager =
      [BVLocaleServiceManager sharedManager];
  NSAssert(localeServiceManager, @"BVLocaleServiceManager is nil.");

  if (self.isStagingServer) {
    [[BVLogger sharedLogger]
        error:@"WARNING: Using staging server for analytic events. This should "
              @"only be enabled for non-production."];
  }

  return [localeServiceManager
      resourceForService:BVLocaleServiceManagerServiceAnalytics
              withLocale:self.analyticsLocale
         andIsProduction:(!self.isStagingServer)];
}

- (void)setFlushInterval:(NSTimeInterval)newInterval {
  self.queueFlushInterval = newInterval;
}

@end
