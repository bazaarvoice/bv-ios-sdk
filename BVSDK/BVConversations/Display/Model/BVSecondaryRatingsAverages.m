//
//  SecondaryRatingsAverages.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSecondaryRatingsAverages.h"
#import "BVNullHelper.h"

@implementation BVSecondaryRatingsAverages

+ (nullable BVSecondaryRatingsAverages *)createWithDictionary:
    (nullable id)apiResponse {
  if (!apiResponse || ![apiResponse isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  NSMutableDictionary *result = [NSMutableDictionary dictionary];

  NSDictionary *apiObject = (NSDictionary *)apiResponse;

  for (NSString *key in apiObject) {
    NSDictionary *value = apiObject[key];
    id avgRating = value[@"AverageRating"];

    if (avgRating != [NSNull null]) {
      result[key] = avgRating;
    }
  }
  return (BVSecondaryRatingsAverages *)result;
}

@end
