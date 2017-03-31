//
//  BVReviewStatistic.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


#import "BVReviewStatistic.h"
#import "BVNullHelper.h"

@implementation BVReviewStatistic

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse {
    
    self = [super init];
    if(self) {
        
        if (apiResponse == nil || ![apiResponse isKindOfClass:[NSDictionary class]] ) {
            return nil;
        }
        NSDictionary* apiObject = apiResponse;
        
        SET_IF_NOT_NULL(self.totalReviewCount, apiObject[@"TotalReviewCount"])
        SET_IF_NOT_NULL(self.averageOverallRating, apiObject[@"AverageOverallRating"])
        SET_IF_NOT_NULL(self.overallRatingRange, apiObject[@"OverallRatingRange"])
        
        if (!self.totalReviewCount) {
            self.totalReviewCount = [NSNumber numberWithInt:0];
        }
        
        if (!self.averageOverallRating) {
            self.averageOverallRating = [NSNumber numberWithInt:0];
        }
        
        if (!self.overallRatingRange) {
            self.overallRatingRange = [NSNumber numberWithInt:0];
        }
    }
    return self;
}

@end
