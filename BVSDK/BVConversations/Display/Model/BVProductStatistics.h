//
//  ProductStatistics.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVGenericConversationsResult.h"
#import "BVReviewStatistic.h"
#import "BVQAStatistics.h"
#import <Foundation/Foundation.h>

/*
 Statistics about a product - included in `BVBulkRatingsResponse`.
 */
@interface BVProductStatistics : BVGenericConversationsResult

@property(nullable) NSString *productId;
@property(nullable) BVReviewStatistic *reviewStatistics;
@property(nullable) BVReviewStatistic *nativeReviewStatistics;
@property(nullable) BVQAStatistics *qaStatisctics;

@end
