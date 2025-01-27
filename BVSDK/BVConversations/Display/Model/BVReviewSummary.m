//
//  BVReviewSummary.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVReviewSummary.h"
#import "BVNullHelper.h"

@implementation BVReviewSummary

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {
    if (!apiResponse) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.summary, apiObject[@"summary"])
    SET_IF_NOT_NULL(self.type, apiObject[@"type"])
    SET_IF_NOT_NULL(self.title, apiObject[@"title"])
    SET_IF_NOT_NULL(self.detail, apiObject[@"detail"])
    SET_IF_NOT_NULL(self.disclaimer, apiObject[@"disclaimer"])
    SET_IF_NOT_NULL(self.status, apiObject[@"status"])
  }
  return self;
}

@end
