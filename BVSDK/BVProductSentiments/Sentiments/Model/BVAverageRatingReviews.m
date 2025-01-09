//
//  BVAverageRatingReviews.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVAverageRatingReviews.h"
#import "BVNullHelper.h"

@implementation BVAverageRatingReviews
- (id)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super init])) {
    if (!apiResponse) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.positive, apiObject[@"positive"])
    SET_IF_NOT_NULL(self.negative, apiObject[@"negative"])
    SET_IF_NOT_NULL(self.incentivized, apiObject[@"incentivized"])
    SET_IF_NOT_NULL(self.total, apiObject[@"total"])
  }
  return self;
}

@end
