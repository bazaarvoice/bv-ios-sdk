//
//  BVLogger.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVLogger+Private.h"

#if __has_builtin(__builtin_os_log_format)
#import <os/log.h>
#endif /* OSLog check */

#define BV_LOG_TAG @"<bazaarvoice>"

@interface BVLogger ()
@property(nonatomic, strong) NSPointerArray *listenerList;
@property(nonatomic, strong) dispatch_queue_t serialQueue;
@property(nonatomic, strong) dispatch_queue_t listenerQueue;
@property(nonatomic, assign) BVLogLevel internalLogLevel;
@end

@implementation BVLogger

__strong static BVLogger *sharedLoggerInstance = nil;

+ (nonnull NSString *)logLevelDescription:(BVLogLevel)logLevel {
  switch (logLevel) {
  case BVLogLevelNone:
    return @"none";
    break;
  case BVLogLevelFault:
    return @"fault";
    break;
  case BVLogLevelError:
    return @"error";
    break;
  case BVLogLevelWarning:
    return @"warn";
    break;
  case BVLogLevelInfo:
    return @"info";
    break;
  case BVLogLevelVerbose:
    return @"debug";
    break;
  case BVLogLevelAnalyticsOnly:
    return @"analytics";
    break;
  default:
    return @"nil";
    break;
  }
}

- (void)setLogLevel:(BVLogLevel)logLevel {
  dispatch_sync(self.serialQueue, ^{
    self.internalLogLevel = logLevel;
  });
}

- (BVLogLevel)logLevel {
  __block BVLogLevel blockLogLevel;
  dispatch_sync(self.serialQueue, ^{
    blockLogLevel = self.internalLogLevel;
  });
  return blockLogLevel;
}

+ (BVLogger *)sharedLogger {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedLoggerInstance = [[self alloc] init];
  });
  return sharedLoggerInstance;
}

- (id)init {
  if ((self = [super init])) {
    self.internalLogLevel = BVLogLevelError;
    self.listenerList = [NSPointerArray weakObjectsPointerArray];
    self.serialQueue = dispatch_queue_create(
        "com.bazaarvoice.BVLogger.serialQueue", DISPATCH_QUEUE_SERIAL);
    self.listenerQueue = dispatch_queue_create(
        "com.bazaarvoice.BVLogger.listenerQueue", DISPATCH_QUEUE_SERIAL);
  }
  return self;
}

- (void)analyticsMessage:(nonnull NSString *)message
             withContext:(nullable NSDictionary *)context {
  [self printMessage:message
         forLogLevel:BVLogLevelAnalyticsOnly
         withContext:context];
}

- (void)verbose:(nonnull NSString *)message
    withContext:(nullable NSDictionary *)context {
  [self printMessage:message forLogLevel:BVLogLevelVerbose withContext:context];
}

- (void)info:(nonnull NSString *)message
    withContext:(nullable NSDictionary *)context {
  [self printMessage:message forLogLevel:BVLogLevelInfo withContext:context];
}

- (void)warning:(nonnull NSString *)message
    withContext:(nullable NSDictionary *)context {
  [self printMessage:message forLogLevel:BVLogLevelWarning withContext:context];
}

- (void)error:(nonnull NSString *)message
    withContext:(nullable NSDictionary *)context {
  [self printMessage:message forLogLevel:BVLogLevelError withContext:context];
}

- (void)fault:(nonnull NSString *)message
    withContext:(nullable NSDictionary *)context {
  [self printMessage:message forLogLevel:BVLogLevelFault withContext:context];
}

- (void)printError:(nonnull NSError *)error {
  [self printMessage:[error localizedDescription]
         forLogLevel:BVLogLevelError
         withContext:nil];
}

- (void)printErrors:(nonnull NSArray<NSError *> *)errors {
  for (NSError *error in errors) {
    [self printError:error];
  }
}

- (void)addListener:(nonnull id<BVLogListener>)listener {
  dispatch_sync(self.listenerQueue, ^{
    [self.listenerList addPointer:(__bridge void *_Nullable)(listener)];
  });
}

- (void)removeListener:(nonnull id<BVLogListener>)listener {
  dispatch_sync(self.listenerQueue, ^{
    __block NSInteger indexRemoval = -1;
    [self.listenerList compact];
    [self.listenerList.allObjects
        enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx,
                                     BOOL *_Nonnull stop) {
          if (obj == listener) {
            indexRemoval = idx;
            *stop = YES;
          }
        }];
    if (0 <= indexRemoval) {
      [self.listenerList removePointerAtIndex:(NSUInteger)indexRemoval];
    }
  });
}

- (void)notifyListenersWithLevel:(BVLogLevel)logLevel
                      andMessage:(nonnull NSString *)message
                     withContext:(nullable NSDictionary *)context {
  dispatch_sync(self.listenerQueue, ^{
    [self.listenerList compact];
    [self.listenerList.allObjects enumerateObjectsUsingBlock:^(
                                      id _Nonnull obj, NSUInteger idx,
                                      BOOL *_Nonnull stop) {
      if ([obj respondsToSelector:@selector(logWithLevel:message:context:)]) {
        id<BVLogListener> listener = (id<BVLogListener>)obj;
        [listener logWithLevel:logLevel message:message context:context];
      }
    }];
  });
}

- (void)printMessage:(nonnull NSString *)message
         forLogLevel:(BVLogLevel)logLevel
         withContext:(nullable NSDictionary *)context {
  dispatch_async(self.serialQueue, ^{
    if (!message || 0 == message.length) {
      return;
    }

    [self notifyListenersWithLevel:logLevel
                        andMessage:message
                       withContext:context];

    if (BVLogLevelNone == self.internalLogLevel) {
      return;
    }

    NSString *logMsg =
        [NSString stringWithFormat:@"%@: %@", BV_LOG_TAG, message];

    /// If we have analytics only turned on we bail if the level doesn't match.
    if (BVLogLevelAnalyticsOnly != logLevel &&
        BVLogLevelAnalyticsOnly == self.internalLogLevel) {
      return;
    }

    /// If we have have a level that doesn't match the passed in level we bail
    /// if it's greater.
    if (logLevel > self.internalLogLevel) {
      return;
    }

    [self enqueueMessage:logMsg forLogLevel:logLevel];
  });
}

- (void)enqueueMessage:(nonnull NSString *)message
           forLogLevel:(BVLogLevel)logLevel {

  dispatch_async(dispatch_get_main_queue(), ^{
#if __has_builtin(__builtin_os_log_format)

    if (@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)) {
      const char *msg = [message UTF8String];

      switch (logLevel) {
      case BVLogLevelFault:
        os_log_fault(OS_LOG_DEFAULT, "%{public}s", msg);
        break;
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
