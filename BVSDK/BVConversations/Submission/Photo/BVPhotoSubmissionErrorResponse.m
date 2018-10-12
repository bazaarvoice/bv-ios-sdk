//
//  BVPhotoSubmissionErrorResponse.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVPhotoSubmissionErrorResponse.h"
#import "BVNullHelper.h"

@implementation BVPhotoSubmissionErrorResponse

- (instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    if (__IS_KIND_OF(apiResponse, NSDictionary)) {
      NSDictionary *apiObject = (NSDictionary *)apiResponse;
      self.errorResult =
          [[BVSubmittedPhoto alloc] initWithApiResponse:apiObject[@"Photo"]];
    }
  }
  return self;
}

@end
