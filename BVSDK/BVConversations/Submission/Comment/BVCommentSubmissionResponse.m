//
//  BVCommentSubmissionResponse.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentSubmissionResponse.h"

@implementation BVCommentSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    self.result = [[BVSubmittedComment alloc]
        initWithApiResponse:apiResponse[@"Comment"]];
  }
  return self;
}

@end
