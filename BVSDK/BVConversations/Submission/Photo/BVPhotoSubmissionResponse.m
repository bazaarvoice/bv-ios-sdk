//
//  BVPhotoSubmissionResponse.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVPhotoSubmissionResponse.h"

@implementation BVPhotoSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    self.result =
        [[BVSubmittedPhoto alloc] initWithApiResponse:apiResponse[@"Photo"]];
  }
  return self;
}

@end
