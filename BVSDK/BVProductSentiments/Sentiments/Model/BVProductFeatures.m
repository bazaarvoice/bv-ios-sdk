//
//  BVProductFeatures.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVProductFeatures.h"
#import "BVNullHelper.h"

@implementation BVProductFeatures

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {
    if (!apiResponse) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.features, apiObject[@"features"])
    SET_IF_NOT_NULL(self.status, apiObject[@"status"])
    SET_IF_NOT_NULL(self.title, apiObject[@"title"])
    SET_IF_NOT_NULL(self.detail, apiObject[@"detail"])
    SET_IF_NOT_NULL(self.detail, apiObject[@"detail"])
    SET_IF_NOT_NULL(self.instance, apiObject[@"instance"])
      self.features = [BVProductFeatures parseProductFeature:apiResponse[@"features"]];

  }
  return self;
}

+ (nonnull NSArray<BVProductFeature *> *)parseProductFeature:(nullable id)apiResponse {
    NSMutableArray<BVProductFeature *> *tempValues = [NSMutableArray array];
    NSArray *apiObject = apiResponse;
    for (NSDictionary *object in apiObject) {
        [tempValues addObject:[[BVProductFeature alloc] initWithApiResponse:object]];
    }
    return tempValues;
}

@end
