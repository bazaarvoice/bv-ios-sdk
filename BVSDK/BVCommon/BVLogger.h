//
//  BVLogger.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Values to set the log level for the shared BVLogger.
typedef NS_ENUM(NSUInteger, BVLogLevel) {

  /// No logging.
  BVLogLevelNone = 0,

  /// Log critical faults only.
  BVLogLevelFault = 1,

  /// Log errors only. This is the default setting.
  BVLogLevelError = 2,

  /// Logs errors and warnings only.
  BVLogLevelWarning = 3,

  /// Logs errors, warnings, and info that may assist in tracing while
  /// debugging.
  BVLogLevelInfo = 4,

  /// Logs all info, errors, and warnings, including all API invocations and
  /// responeses.
  BVLogLevelVerbose = 5,

  /// Logs only condensed analytic event information
  BVLogLevelAnalyticsOnly = 6
};

/// The logging notification protocol. Register your class here if you want to
/// be able to direct logging to your own facility.
@protocol BVLogListener <NSObject>
- (void)logWithLevel:(BVLogLevel)logLevel
             message:(nonnull NSString *)message
             context:(nullable NSDictionary *)context;
@end

/// BVLogger is used for logging debug and informational messages from the SDK.
@interface BVLogger : NSObject

/// Singleton object. Use [BVLogger sharedLogger] whenever interacting with the
/// logger.
+ (nonnull BVLogger *)sharedLogger;

/// Only messages of |logLevel| and below are logged.
@property(nonatomic, assign) BVLogLevel logLevel;

/// Logs all errors with log level BVLogLevelError.
- (void)printError:(nonnull NSError *)error;

/// Logs all errors with log level BVLogLevelError.
- (void)printErrors:(nonnull NSArray<NSError *> *)errors;

/// Logs message with log level BVLogLevelVerbose.
- (void)verbose:(nonnull NSString *)message
    withContext:(nullable NSDictionary *)context;

/// Logs message with log level BVLogLevelInfo.
- (void)info:(nonnull NSString *)message
    withContext:(nullable NSDictionary *)context;

/// Logs message with log level BVLogLevelWarning.
- (void)warning:(nonnull NSString *)message
    withContext:(nullable NSDictionary *)context;

/// Logs message with log level BVLogLevelError.
- (void)error:(nonnull NSString *)message
    withContext:(nullable NSDictionary *)context;

/// Logs message with log level BVLogLevelFault.
- (void)fault:(nonnull NSString *)message
    withContext:(nullable NSDictionary *)context;

/// Logs messages specific to analytic events that this SDK fires
- (void)analyticsMessage:(nonnull NSString *)message
             withContext:(nullable NSDictionary *)context;

/// Add a log listener
- (void)addListener:(nonnull id<BVLogListener>)listener;

/// Remove a log listener
- (void)removeListener:(nonnull id<BVLogListener>)listener;

@end
