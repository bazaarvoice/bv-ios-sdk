//
//  DimensionAndDistributionUtil.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDimensionAndDistributionUtil+Private.h"

@implementation BVDimensionAndDistributionUtil

+ (nullable TagDistribution)createDistributionWithApiResponse:
    (nullable id)apiResponse {
  if (!apiResponse) {
    return nil;
  }

  NSDictionary<NSString *, NSDictionary *> *apiObject =
      (NSDictionary<NSString *, NSDictionary *> *)apiResponse;
  TagDistribution tempValues = [NSMutableDictionary dictionary];
  for (NSString *key in apiObject) {
    NSDictionary *value = [apiObject objectForKey:key];
    BVDistributionElement *element =
        [[BVDistributionElement alloc] initWithApiResponse:value];
    [tempValues setObject:element forKey:key];
  }

  return tempValues;
}

+ (nullable SecondaryRatingsDistribution)createSecondaryRatingsDistributionWithApiResponse:
    (nullable id)apiResponse {
  if (!apiResponse) {
    return nil;
  }

  NSDictionary<NSString *, NSDictionary *> *apiObject =
      (NSDictionary<NSString *, NSDictionary *> *)apiResponse;
  SecondaryRatingsDistribution tempValues = [NSMutableDictionary dictionary];
  for (NSString *key in apiObject) {
    NSDictionary *value = [apiObject objectForKey:key];
    BVSecondaryRatingsDistributionElement *element =
        [[BVSecondaryRatingsDistributionElement alloc] initWithApiResponse:value];
    [tempValues setObject:element forKey:key];
  }

  return tempValues;
}

@end
