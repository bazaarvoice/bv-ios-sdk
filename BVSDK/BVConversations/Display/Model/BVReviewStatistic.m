//
//  BVReviewStatistic.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewStatistic.h"
#import "BVNullHelper.h"

@implementation BVReviewStatistic

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {

    if (!apiResponse || ![apiResponse isKindOfClass:[NSDictionary class]]) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.totalReviewCount, apiObject[@"TotalReviewCount"])
    SET_IF_NOT_NULL(self.averageOverallRating,
                    apiObject[@"AverageOverallRating"])
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
