//
//  BVReviewStatistics.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewStatistics.h"
#import "BVModelUtil.h"
#import "BVNullHelper.h"

@implementation BVReviewStatistics

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse {
    self = [super init];
    if(self) {
        if (apiResponse == nil || ![apiResponse isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        NSDictionary* apiObject = apiResponse;
        
        SET_IF_NOT_NULL(self.helpfulVoteCount, apiObject[@"HelpfulVoteCount"])
        SET_IF_NOT_NULL(self.notRecommendedCount, apiObject[@"NotRecommendedCount"])
        SET_IF_NOT_NULL(self.averageOverallRating, apiObject[@"AverageOverallRating"])
        SET_IF_NOT_NULL(self.featuredReviewCount, apiObject[@"FeaturedReviewCount"])
        SET_IF_NOT_NULL(self.notHelpfulVoteCount, apiObject[@"NotHelpfulVoteCount"])
        SET_IF_NOT_NULL(self.overallRatingRange, apiObject[@"OverallRatingRange"])
        SET_IF_NOT_NULL(self.totalReviewCount, apiObject[@"TotalReviewCount"])
        SET_IF_NOT_NULL(self.ratingsOnlyReviewCount, apiObject[@"RatingsOnlyReviewCount"])
        SET_IF_NOT_NULL(self.recommendedCount, apiObject[@"RecommendedCount"])
        
        self.secondaryRatingsAverages = [BVSecondaryRatingsAverages createWithDictionary:apiObject[@"SecondaryRatingsAverages"]];
        self.tagDistribution = [BVDimensionAndDistributionUtil createDistributionWithApiResponse:apiObject[@"TagDistribution"]];
        self.contextDataDistribution = [BVDimensionAndDistributionUtil createDistributionWithApiResponse:apiObject[@"ContextDataDistribution"]];
        
        self.firstSubmissionTime = [BVModelUtil convertTimestampToDatetime:apiObject[@"FirstSubmissionTime"]];
        self.lastSubmissionTime = [BVModelUtil convertTimestampToDatetime:apiObject[@"LastSubmissionTime"]];
        
        self.ratingDistribution = [[BVRatingDistribution alloc] initWithApiResponse:apiObject[@"RatingDistribution"]];

    }
    return self;
}

@end
