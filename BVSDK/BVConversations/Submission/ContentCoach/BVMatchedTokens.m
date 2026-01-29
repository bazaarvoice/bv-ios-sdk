//
//  BVMatchedTokens.m
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

#import "BVMatchedTokens.h"
#import "BVNullHelper.h"

@implementation BVMatchedTokens

- (id)initWithApiResponse:(nullable NSDictionary *)apiResponse {
  if ((self = [super init])) {
    SET_IF_NOT_NULL(self.status, apiResponse[@"status"])
    SET_IF_NOT_NULL(self.type, apiResponse[@"type"])
    SET_IF_NOT_NULL(self.title, apiResponse[@"title"])
    SET_IF_NOT_NULL(self.detail, apiResponse[@"detail"])
    SET_IF_NOT_NULL(self.data, apiResponse[@"data"])
  }
  return self;
}

@end
