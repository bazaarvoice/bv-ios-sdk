//
//  BVAnalyticsRemoteLogger.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVLogger.h"

@class BVRemoteLogEvent;
@interface BVAnalyticsRemoteLogger : NSObject

/// Create and get the singleton instance of the remote logger.
+ (BVAnalyticsRemoteLogger *)sharedRemoteLogger;

/// Only messages of |logLevel| and below are logged.
@property(nonatomic, assign) BVLogLevel logLevel;

@end
