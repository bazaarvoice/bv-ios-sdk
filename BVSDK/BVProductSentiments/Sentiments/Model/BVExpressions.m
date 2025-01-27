//
//  BVExpressions.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVExpressions.h"
#import "BVNullHelper.h"

@implementation BVExpressions

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {
    if (!apiResponse) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.nativeFeature, apiObject[@"nativeFeature"])
    SET_IF_NOT_NULL(self.expressions, apiObject[@"expressions"])
    SET_IF_NOT_NULL(self.status, apiObject[@"status"])
    SET_IF_NOT_NULL(self.title, apiObject[@"title"])
    SET_IF_NOT_NULL(self.detail, apiObject[@"detail"])
    SET_IF_NOT_NULL(self.detail, apiObject[@"detail"])
    SET_IF_NOT_NULL(self.instance, apiObject[@"instance"])
  }
  return self;
}

@end
