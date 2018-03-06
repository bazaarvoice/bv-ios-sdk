//
//  ProductStatistics.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewStatistic.h"
#import <Foundation/Foundation.h>

/*
 Statistics about a product - included in `BVBulkRatingsResponse`.
 */
@interface BVProductStatistics : NSObject

@property(nullable) NSString *productId;
@property(nullable) BVReviewStatistic *reviewStatistics;
@property(nullable) BVReviewStatistic *nativeReviewStatistics;

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end
