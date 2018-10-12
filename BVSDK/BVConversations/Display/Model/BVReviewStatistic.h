//
//  BVReviewStatistic.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 A set of statistics about reviews. Used in `BVProductStatistics`.
 */
@interface BVReviewStatistic : NSObject

@property(nullable) NSNumber *totalReviewCount;
@property(nullable) NSNumber *averageOverallRating;
@property(nullable) NSNumber *overallRatingRange;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
