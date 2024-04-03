//
//  BVVideoSubmissionErrorResponse.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import "BVVideoSubmissionErrorResponse.h"
#import "BVNullHelper.h"

@implementation BVVideoSubmissionErrorResponse

- (instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    if (__IS_KIND_OF(apiResponse, NSDictionary)) {
      NSDictionary *apiObject = (NSDictionary *)apiResponse;
      self.errorResult =
          [[BVSubmittedVideo alloc] initWithApiResponse:apiObject[@"Video"]];
    }
  }
  return self;
}

@end
