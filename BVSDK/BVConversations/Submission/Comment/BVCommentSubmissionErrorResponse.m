//
//  BVCommentSubmissionErrorResponse.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentSubmissionErrorResponse.h"
#import "BVNullHelper.h"

@implementation BVCommentSubmissionErrorResponse

- (instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    if (__IS_KIND_OF(apiResponse, NSDictionary)) {
      NSDictionary *apiObject = (NSDictionary *)apiResponse;
      self.errorResult = [[BVSubmittedComment alloc]
          initWithApiResponse:apiObject[@"Comment"]];
    }
  }
  return self;
}

@end
