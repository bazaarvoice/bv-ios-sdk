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
    
    /// Log errors only. This is the default setting.
    BVLogLevelError = 1,
    
    /// Logs errors and warnings only.
    BVLogLevelWarning = 2,
    
    /// Logs errors, warnings, and info that may assist in tracing while debugging.
    BVLogLevelInfo = 3,
    
    /// Logs all info, errors, and warnings, including all API invocations and responeses.
    BVLogLevelVerbose = 4,
    
    /// Logs only condensed analytic event information
    BVLogLevelAnalyticsOnly = 5
    
};


/// BVLogger is used for logging debug and informational messages from the SDK.
@interface BVLogger : NSObject


/// Singleton object. Use [BVLogger sharedLogger] whenever interacting with the logger.
+(nonnull BVLogger*)sharedLogger;


/// Only messages of |logLevel| and below are logged.
@property (nonatomic, assign) BVLogLevel logLevel;


/// Logs message with log level BVLogLevelVerbose.
- (void)verbose:(nonnull NSString*) message;


/// Logs message with log level BVLogLevelInfo.
- (void)info:(nonnull NSString*)message;


/// Logs message with log level BVLogLevelWarning.
- (void)warning:(nonnull NSString*)message;


/// Logs message with log level BVLogLevelError.
- (void)error:(nonnull NSString*)message;


/// Logs all errors with log level BVLogLevelError.
-(void)printError:(nonnull NSError*)error;


/// Logs all errors with log level BVLogLevelError.
-(void)printErrors:(nonnull NSArray<NSError*>*)errors;


/// Logs messages specific to analytic events that this SDK fires internally
-(void)analyticsMessage:(nonnull NSString*)message;


@end
