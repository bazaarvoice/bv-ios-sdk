//
//  BVSummarisedFeatures.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import "BVSummarisedFeatures.h"
#import "BVNullHelper.h"

@implementation BVSummarisedFeatures 
- (id)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super init])) {
    if (!apiResponse) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;
      
    SET_IF_NOT_NULL(self.bestFeatures, apiObject[@"bestFeatures"])
    SET_IF_NOT_NULL(self.worstFeatures, apiObject[@"worstFeatures"])
    SET_IF_NOT_NULL(self.status, apiObject[@"status"])
    SET_IF_NOT_NULL(self.title, apiObject[@"title"])
    SET_IF_NOT_NULL(self.detail, apiObject[@"detail"])
    SET_IF_NOT_NULL(self.detail, apiObject[@"detail"])
    SET_IF_NOT_NULL(self.instance, apiObject[@"instance"])
  }
  return self;
}

@end
