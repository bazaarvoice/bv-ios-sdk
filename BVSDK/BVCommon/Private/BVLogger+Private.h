//
//  BVLogger+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVLOGGER_PRIVATE_H
#define BVLOGGER_PRIVATE_H

#import "BVLogger.h"

#define BVAssert(EXPR, ...)                                                    \
  do {                                                                         \
    if (!(EXPR)) {                                                             \
      NSString *__BVAssert_temp_string = [NSString                             \
          stringWithFormat:@"Assertion failure: %s in %s on line %s:%d. %@",   \
                           #EXPR, __func__, __FILE__, __LINE__,                \
                           [NSString stringWithFormat:@"" __VA_ARGS__]];       \
      [[BVLogger sharedLogger] error:__BVAssert_temp_string];                  \
      abort();                                                                 \
    }                                                                          \
  } while (NO)

#define __BVLog(LEVEL, MSG, CTX)                                               \
  do {                                                                         \
    NSString *unwrapLog = (MSG);                                               \
    NSString *logMsg = [NSString                                               \
        stringWithFormat:@"[%s:%d] %@", __func__, __LINE__, unwrapLog];        \
    [[BVLogger sharedLogger] printMessage:logMsg                               \
                              forLogLevel:LEVEL                                \
                              withContext:CTX];                                \
  } while (NO)

#define BVLogAnalytics(MSG, CTX) __BVLog(BVLogLevelAnalyticsOnly, MSG, CTX)
#define BVLogVerbose(MSG, CTX) __BVLog(BVLogLevelVerbose, MSG, CTX)
#define BVLogInfo(MSG, CTX) __BVLog(BVLogLevelInfo, MSG, CTX)
#define BVLogWarning(MSG, CTX) __BVLog(BVLogLevelWarning, MSG, CTX)
#define BVLogError(MSG, CTX) __BVLog(BVLogLevelError, MSG, CTX)
#define BVLogFault(MSG, CTX) __BVLog(BVLogLevelFault, MSG, CTX)

#define BV_PRODUCT_LOGGING_KEY @"bvproduct"
#define BV_IGNORE_REMOTE_LOGGING_KEY @"ignore_remote_logging"
#define BV_IGNORE_REMOTE_LOGGING @{@"ignore_remote_logging" : @YES}

#define BV_PRODUCT_ANALYTICS @{BV_PRODUCT_LOGGING_KEY : @"Analytics"}
#define BV_PRODUCT_COMMON @{BV_PRODUCT_LOGGING_KEY : @"Common"}
#define BV_PRODUCT_COMMON_UI @{BV_PRODUCT_LOGGING_KEY : @"CommonUI"}
#define BV_PRODUCT_CONVERSATIONS @{BV_PRODUCT_LOGGING_KEY : @"Conversations"}
#define BV_PRODUCT_CONVERSATIONS_STORES                                        \
  @{BV_PRODUCT_LOGGING_KEY : @"ConversationsStores"}
#define BV_PRODUCT_CONVERSATIONS_UI                                            \
  @{BV_PRODUCT_LOGGING_KEY : @"ConversationsUI"}
#define BV_PRODUCT_CURATIONS @{BV_PRODUCT_LOGGING_KEY : @"Curations"}
#define BV_PRODUCT_CURATIONS_UI @{BV_PRODUCT_LOGGING_KEY : @"CurationsUI"}
#define BV_PRODUCT_DREAMCATCHER                                            \
@{BV_PRODUCT_LOGGING_KEY : @"Dreamcatcher"}
#define BV_PRODUCT_NOTIFICATIONS @{BV_PRODUCT_LOGGING_KEY : @"Notifications"}
#define BV_PRODUCT_PERSONALIZATION                                             \
  @{BV_PRODUCT_LOGGING_KEY : @"Personalization"}

@interface BVLogger ()
+ (nonnull NSString *)logLevelDescription:(BVLogLevel)logLevel;

- (void)printMessage:(nonnull NSString *)message
         forLogLevel:(BVLogLevel)logLevel
         withContext:(nullable NSDictionary *)context;
@end

#endif /* BVLOGGER_PRIVATE_H */
