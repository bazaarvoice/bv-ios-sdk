//
//  BVGenericDimensionElement.m
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

#import "BVSecondaryRatingsDistributionElement.h"
#import "BVNullHelper.h"

@implementation BVSecondaryRatingsDistributionElement

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  if ((self = [super init])) {
    SET_IF_NOT_NULL(self.label, apiResponse[@"Label"])
    SET_IF_NOT_NULL(self.identifier, apiResponse[@"Id"])

    NSMutableArray *tempValues = [NSMutableArray array];
    for (NSDictionary *value in apiResponse[@"Values"]) {
        BVSecondaryRatingsDistributionValue *distributionValue =
          [[BVSecondaryRatingsDistributionValue alloc] initWithApiResponse:value];
      [tempValues addObject:distributionValue];
    }
    self.values = tempValues;
  }
  return self;
}

@end
