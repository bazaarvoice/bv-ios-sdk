//
//  BVSecondaryRatingsDistributionValue.m
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

#import "BVSecondaryRatingsDistributionValue.h"
#import "BVNullHelper.h"

@implementation BVSecondaryRatingsDistributionValue

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  if ((self = [super init])) {
    SET_IF_NOT_NULL(self.value, apiResponse[@"Value"])
    SET_IF_NOT_NULL(self.count, apiResponse[@"Count"])
    SET_IF_NOT_NULL(self.valueLabel, apiResponse[@"ValueLabel"])
  }
  return self;
}

@end
