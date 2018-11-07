//
//  BVAnalyticsRemoteLogger.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVAnalyticsManager+Testing.h"
#import "BVAnalyticsRemoteLogger+Testing.h"
#import "BVLogger+Private.h"
#import "BVNetworkingManager.h"
#import "BVRemoteLogEvent.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager+Private.h"
#import "BVUserAgent+NSURLRequest.h"

@interface BVAnalyticsRemoteLogger () <BVLogListener>
@property(nonatomic, strong) dispatch_queue_t serialQueue;
@property(nonatomic, assign) BVLogLevel internalLogLevel;
@end

@implementation BVAnalyticsRemoteLogger

- (void)setLogLevel:(BVLogLevel)logLevel {
  dispatch_sync(self.serialQueue, ^{
    self.internalLogLevel = logLevel;
  });
}

- (BVLogLevel)logLevel {
  __block BVLogLevel blockSafeLogLevel = BVLogLevelFault;
  dispatch_sync(self.serialQueue, ^{
    blockSafeLogLevel = self.internalLogLevel;
  });
  return blockSafeLogLevel;
}

static BVAnalyticsRemoteLogger *remoteLoggerInstance = nil;
+ (BVAnalyticsRemoteLogger *)sharedRemoteLogger {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    remoteLoggerInstance = [[self alloc] init];
  });

  return remoteLoggerInstance;
}

- (instancetype)init {
  if ((self = [super init])) {
    self.serialQueue = dispatch_queue_create(
        "com.bazaarvoice.BVAnalyticsRemoteLogger.serialQueue",
        DISPATCH_QUEUE_SERIAL);
    self.internalLogLevel = BVLogLevelFault;

    /// Add this singleton as a BVLoggerListener
    [[BVLogger sharedLogger] addListener:self];
  }
  return self;
}

- (void)dealloc {
  /// Remove this singleton as a BVLoggerListener
  [[BVLogger sharedLogger] removeListener:self];
}

- (void)logWithLevel:(BVLogLevel)logLevel
             message:(NSString *)message
             context:(nullable NSDictionary *)context {

  if (!message || 0 == message.length) {
    return;
  }

  dispatch_async(self.serialQueue, ^{
    if (BVLogLevelNone == self.internalLogLevel) {
      return;
    }

    if (BVLogLevelAnalyticsOnly == logLevel &&
        BVLogLevelAnalyticsOnly != self.internalLogLevel) {
      return;
    }

    if (logLevel > self.internalLogLevel) {
      return;
    }

    /// So if we log within the remote logging machinery, we don't send an echo
    /// of infinite remote logs...
    id ignoreObj = [context valueForKey:BV_IGNORE_REMOTE_LOGGING_KEY];
    if (__IS_KIND_OF(ignoreObj, NSNumber)) {
      NSNumber *ignore = (NSNumber *)ignoreObj;
      if (ignore.boolValue) {
        return;
      }
    }

    NSString *bvProduct = nil;
    id bvProductObj = [context valueForKey:BV_PRODUCT_LOGGING_KEY];
    if (__IS_KIND_OF(bvProductObj, NSString)) {
      bvProduct = (NSString *)bvProductObj;
    }

    NSString *localeIdentifier =
        BVSDKManager.sharedManager.configuration.analyticsLocaleIdentifier;

    /// Send error event
    BVRemoteLogEvent *logEvent = [[BVRemoteLogEvent alloc]
           initWithError:[BVLogger logLevelDescription:logLevel]
        localeIdentifier:localeIdentifier
                     log:message
               bvProduct:bvProduct];

    /// Craft the completion handler based on whether this is DEBUG or !DEBUG
    /// build. If we're DEBUG we check to see if we have the testing block set,
    /// else we compile that out.
    void (^remoteLogCompletion)(NSError *) = ^void(NSError *_Nullable error) {
#ifdef DEBUG
      /// If we're testing this flow...
      if (self.remoteLogTestingCompletionBlock) {
        self.remoteLogTestingCompletionBlock(logEvent, error);
      }
#else
      /// We should trap if this is a fault in a production build
      if (BVLogLevelFault == logLevel) {
        NSException *exception =
            [NSException exceptionWithName:@"BVSDK Runtime Fault"
                                    reason:message
                                  userInfo:nil];
        [exception raise];
      }
#endif /* DEBUG */
    };

    /// Send the remote event
    [self sendRemoteLogEvent:logEvent
        withCompletionHandler:remoteLogCompletion];
  });
}

- (void)sendRemoteLogEvent:(nonnull BVRemoteLogEvent *)eventData
     withCompletionHandler:
         (void (^)(NSError *__nullable error))completionHandler {
  NSURL *url = [NSURL URLWithString:[BVAnalyticsManager.sharedManager baseUrl]];
  NSURLSession *session =
      [BVNetworkingManager sharedManager].bvNetworkingSession;

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"POST";
  [request setValue:@"application/json"
      forHTTPHeaderField:@"Content-Type"]; // content type
  [request setValue:[NSURLRequest
                        bvUserAgentWithLocaleIdentifier:eventData
                                                            .localeIdentifier]
      forHTTPHeaderField:@"User-Agent"];

  NSError *error = nil;
  NSData *data = [NSJSONSerialization dataWithJSONObject:eventData.toRaw
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
                  BVLogError(errorMsg, BV_IGNORE_REMOTE_LOGGING);

                } else {
                  BVLogError(
                      ([NSString stringWithFormat:@"ERROR: Posting "
                                                  @"analytics event "
                                                  @"failed with "
                                                  @"status: %ld and "
                                                  @"error: %@",
                                                  (long)httpResponse.statusCode,
                                                  error]),
                      BV_IGNORE_REMOTE_LOGGING);
                }

              } else {
                // Successful analyatics event sent
                NSString *message = [NSString
                    stringWithFormat:@"Analytics event sent successfully."];
                BVLogAnalytics(message, BV_IGNORE_REMOTE_LOGGING);
              }

              dispatch_barrier_async(self.serialQueue, ^{
                completionHandler(error);
              });

            }];

    [postTask resume];
  };
}

@end
