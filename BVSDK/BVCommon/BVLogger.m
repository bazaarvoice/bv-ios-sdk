//
//  BVLogger.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVLogger.h"

#if __has_builtin(__builtin_os_log_format)
#import <os/log.h>
#endif /* OSLog check */

#define BV_LOG_TAG @"<bazaarvoice>"

@implementation BVLogger

__strong static BVLogger *sharedLoggerInstance = nil;

+ (BVLogger *)sharedLogger {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedLoggerInstance = [[self alloc] init];
  });
  return sharedLoggerInstance;
}

- (id)init {
  if ((self = [super init])) {
    self.logLevel = BVLogLevelError;
  }
  return self;
}

- (void)analyticsMessage:(nonnull NSString *)message {
  [self printMessage:message forLogLevel:BVLogLevelAnalyticsOnly];
}

- (void)verbose:(nonnull NSString *)message {
  [self printMessage:message forLogLevel:BVLogLevelVerbose];
}

- (void)info:(nonnull NSString *)message {
  [self printMessage:message forLogLevel:BVLogLevelInfo];
}

- (void)warning:(nonnull NSString *)message {
  [self printMessage:message forLogLevel:BVLogLevelWarning];
}

- (void)error:(nonnull NSString *)message {
  [self printMessage:message forLogLevel:BVLogLevelError];
}

- (void)printError:(nonnull NSError *)error {
  [self printMessage:[error localizedDescription] forLogLevel:BVLogLevelError];
}

- (void)printErrors:(nonnull NSArray<NSError *> *)errors {
  for (NSError *error in errors) {
    [self printError:error];
  }
}

- (void)printMessage:(nonnull NSString *)message
         forLogLevel:(BVLogLevel)logLevel {

  if (BVLogLevelNone == self.logLevel || !message || 0 == message.length) {
    return;
  }

  NSString *logMsg = [NSString stringWithFormat:@"%@: %@", BV_LOG_TAG, message];

  if (BVLogLevelAnalyticsOnly == logLevel &&
      BVLogLevelAnalyticsOnly == self.logLevel) {
    [self enqueueMessage:logMsg forLogLevel:logLevel];
    return;
  }

  if (logLevel <= self.logLevel) {
    [self enqueueMessage:logMsg forLogLevel:logLevel];
  }
}

- (void)enqueueMessage:(nonnull NSString *)message
           forLogLevel:(BVLogLevel)logLevel {

  dispatch_async(dispatch_get_main_queue(), ^{
#if __has_builtin(__builtin_os_log_format)

    if (@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)) {
      const char *msg = [message UTF8String];

      switch (logLevel) {

      case BVLogLevelError:
        os_log_error(OS_LOG_DEFAULT, "%{public}s", msg);
        break;
      case BVLogLevelAnalyticsOnly:
      case BVLogLevelWarning:
      case BVLogLevelInfo:
        os_log_info(OS_LOG_DEFAULT, "%{public}s", msg);
        break;
      case BVLogLevelVerbose:
      default:
        os_log_debug(OS_LOG_DEFAULT, "%{public}s", msg);
        break;
      }
    }

#endif /* OSLog check */

    /// We'll log to both loggers for the time being
    NSLog(@"%@", message);
  });
}

@end
