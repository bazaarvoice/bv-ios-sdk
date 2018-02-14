//
//  BVCommentSubmissionResponse.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentSubmissionResponse.h"

@implementation BVCommentSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {

  self = [super initWithApiResponse:apiResponse];

  if (self) {
    self.comment = [[BVSubmittedComment alloc]
        initWithApiResponse:apiResponse[@"Comment"]];
  }

  return self;
}

@end
