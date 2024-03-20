//
//  BVVideoSubmissionResponse.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import "BVVideoSubmissionResponse.h"

@implementation BVVideoSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    self.result =
        [[BVSubmittedVideo alloc] initWithApiResponse:apiResponse[@"video"]];
  }
  return self;
}

@end
