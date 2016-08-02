//
//  ReviewStatistics.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSecondaryRatingsAverages.h"
#import "BVRatingDistribution.h"
#import "BVDimensionAndDistributionUtil.h"

/*
 Statistics about the reviews about a product.
 */
@interface BVReviewStatistics : NSObject

@property NSNumber* _Nullable helpfulVoteCount;
@property NSNumber* _Nullable notRecommendedCount;
@property NSNumber* _Nullable averageOverallRating;
@property NSNumber* _Nullable featuredReviewCount;
@property NSNumber* _Nullable notHelpfulVoteCount;
@property NSNumber* _Nullable overallRatingRange;
@property NSNumber* _Nullable totalReviewCount;
@property NSNumber* _Nullable ratingsOnlyReviewCount;
@property NSNumber* _Nullable recommendedCount;

@property BVSecondaryRatingsAverages* _Nullable secondaryRatingsAverages;
@property BVRatingDistribution* _Nullable ratingDistribution;

@property TagDistribution _Nullable tagDistribution;
@property ContextDataDistribution _Nullable contextDataDistribution;

@property NSDate* _Nullable firstSubmissionTime;
@property NSDate* _Nullable lastSubmissionTime;

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse;

@end
