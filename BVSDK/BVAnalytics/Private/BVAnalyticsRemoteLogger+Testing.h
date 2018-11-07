//
//  BVAnalyticsRemoteLogger+Testing.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVANALYTICSREMOTELOGGER_TESTING_H
#define BVANALYTICSREMOTELOGGER_TESTING_H

#import "BVAnalyticsRemoteLogger.h"

@interface BVAnalyticsRemoteLogger ()

/// Simple closure callback to trace log events back for testing.
@property(nonatomic, copy, nullable) void (^remoteLogTestingCompletionBlock)
    (BVRemoteLogEvent *__nonnull remoteLog, NSError *__nullable error);

/// Main method to send off a remote log event
- (void)sendRemoteLogEvent:(nonnull BVRemoteLogEvent *)eventData
     withCompletionHandler:
         (void (^)(NSError *__nullable error))completionHandler;

@end

#endif /* BVANALYTICSREMOTELOGGER_TESTING_H */
