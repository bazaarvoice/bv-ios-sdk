//
//  BVAnalyticsManager+Testing.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVANALYTICSMANAGER_TESTING_H
#define BVANALYTICSMANAGER_TESTING_H

#import "BVAnalyticsManager.h"

@interface BVAnalyticsManager ()

- (void)enqueueImpressionTestWithName:(NSString *)testName
                  withCompletionBlock:(dispatch_block_t)completionBlock;

- (void)enqueuePageViewTestWithName:(NSString *)testName
                withCompletionBlock:(dispatch_block_t)completionBlock;

/// Set queue flush interval for batch dequeueing.
- (void)setFlushInterval:(NSTimeInterval)newFlushInterval;

@end

#endif /* BVANALYTICSMANAGER_TESTING_H */
