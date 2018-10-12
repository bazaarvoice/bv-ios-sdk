//
//  BVUASSubmissionResponse.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVUASSubmissionResponse.h"

@implementation BVUASSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    self.result = [[BVSubmittedUAS alloc]
        initWithApiResponse:apiResponse[@"Authentication"]];
  }
  return self;
}

@end
