//
//  BVFeature.m
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

#import "BVFeature.h"
#import "BVNullHelper.h"

@implementation BVFeature

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {
    if (!apiResponse) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.feature, apiObject[@"feature"])
    SET_IF_NOT_NULL(self.localizedFeature, apiObject[@"localizedFeature"])
  }
  return self;
}

@end
