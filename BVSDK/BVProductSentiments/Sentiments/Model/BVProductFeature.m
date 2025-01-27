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
    SET_IF_NOT_NULL(self.reviewsMentioned, apiObject[@"reviewsMentioned"])
    SET_IF_NOT_NULL(self.averageRatingReviews, apiObject[@"averageRatingReviews"])
    SET_IF_NOT_NULL(self.embedded, apiObject[@"_embedded"])
  }
  return self;
}

@end
