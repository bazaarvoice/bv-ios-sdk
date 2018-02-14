//
//  BVReviewStatistics.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDimensionAndDistributionUtil.h"
#import "BVRatingDistribution.h"
#import "BVSecondaryRatingsAverages.h"
#import <Foundation/Foundation.h>

/*
 Statistics about the reviews about a product.
 */
@interface BVReviewStatistics : NSObject

@property(nullable) NSNumber *helpfulVoteCount;
@property(nullable) NSNumber *notRecommendedCount;
@property(nullable) NSNumber *averageOverallRating;
@property(nullable) NSNumber *featuredReviewCount;
@property(nullable) NSNumber *notHelpfulVoteCount;
@property(nullable) NSNumber *overallRatingRange;
@property(nullable) NSNumber *totalReviewCount;
@property(nullable) NSNumber *ratingsOnlyReviewCount;
@property(nullable) NSNumber *recommendedCount;

@property(nullable) BVSecondaryRatingsAverages *secondaryRatingsAverages;
@property(nullable) BVRatingDistribution *ratingDistribution;

@property(nullable) TagDistribution tagDistribution;
@property(nullable) ContextDataDistribution contextDataDistribution;

@property(nullable) NSDate *firstSubmissionTime;
@property(nullable) NSDate *lastSubmissionTime;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
