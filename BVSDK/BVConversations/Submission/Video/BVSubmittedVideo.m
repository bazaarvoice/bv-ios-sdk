//
//  BVSubmittedVideo.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import "BVSubmittedVideo.h"
#import "BVNullHelper.h"

@implementation BVSubmittedVideo

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {

    if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;
    self.video = [[BVVideo alloc] initWithApiResponse:apiObject];
  }
  return self;
}

@end
