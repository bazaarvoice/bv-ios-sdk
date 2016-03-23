//
//  BVLogger.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Values to set the log level for the shared BVLogger.
 */
typedef NS_ENUM(NSUInteger, BVLogLevel) {
    /**
     *  No logging.
     */
    BVLogLevelNone = 0,
    /**
     *  Log errors only. This is the default setting.
     */
    BVLogLevelError = 1,
    /**
     *  Logs errors and warnings only.
     */
    BVLogLevelWarning = 2,
    /**
     *  Logs errors, warnings, and info that may assist in tracing while debugging.
     */
    BVLogLevelInfo = 3,
    /**
     *  Logs all info, errors, and warnings, including all API invocations and responeses.
     */
    BVLogLevelVerbose = 4,
    /**
     *  Logs only condensed analytic event information
     */
    BVLogLevelAnalyticsOnly = 5
};

/*!
 BVLogger is used for logging debug and informational messages from the SDK.
 */
@interface BVLogger : NSObject

/*!
 Singleton object.
 */
+(BVLogger*)sharedLogger;

/*!
 Only messages of |logLevel| and below are logged.
 */
@property (nonatomic, assign) BVLogLevel logLevel;


/**
 *  Logs message with log level BVLogLevelVerbose.
 *
 *  @param message The message to log
 */
- (void)verbose:(NSString*) message;


/**
 *  Logs message with log level BVLogLevelInfo.
 *
 *  @param message The message to log
 */
- (void)info:(NSString*)message;

/**
 *  Logs message with log level BVLogLevelWarning.
 *
 *  @param message The message to log
 */
- (void)warning:(NSString*)message;


/**
 *  Logs message with log level BVLogLevelError.
 *
 *  @param message The message to log
 */
- (void)error:(NSString*)message;

/**
 *  Logs messages specific to analytic events that this SDK fires internally
 *
 *  @param message The message to log
 */
-(void)analyticsMessage:(NSString*)message;

@end
