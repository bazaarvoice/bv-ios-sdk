//
//  BVReviewSubmissionErrorResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewSubmissionErrorResponse.h"
#import "BVNullHelper.h"

@implementation BVReviewSubmissionErrorResponse

- (instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    if (__IS_KIND_OF(apiResponse, NSDictionary)) {
      NSDictionary *apiObject = (NSDictionary *)apiResponse;
      self.errorResult =
          [[BVSubmittedReview alloc] initWithApiResponse:apiObject[@"Review"]];
    }
  }
  return self;
}

@end
