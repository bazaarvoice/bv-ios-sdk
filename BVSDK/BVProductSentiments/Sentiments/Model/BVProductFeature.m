//
//  BVProductFeature.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVProductFeature.h"
#import "BVNullHelper.h"

@implementation BVProductFeature

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {
    if (!apiResponse) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.feature, apiObject[@"feature"])
    SET_IF_NOT_NULL(self.featureID, apiObject[@"featureId"])
    SET_IF_NOT_NULL(self.percentPositive, apiObject[@"percentPositive"])
    SET_IF_NOT_NULL(self.nativeFeature, apiObject[@"nativeFeature"])
    self.reviewsMentioned = [[BVAverageRatingReviews alloc] initWithApiResponse:apiResponse[@"reviewsMentioned"]];
    self.averageRatingReviews = [[BVAverageRatingReviews alloc] initWithApiResponse:apiResponse[@"averageRatingReviews"]];
    self.embedded = [[BVQuotes alloc] initWithApiResponse:apiResponse[@"_embedded"]];

  }
  return self;
}

@end
