//
//  BVReviewSubmissionErrorResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewSubmissionErrorResponse.h"

@implementation BVReviewSubmissionErrorResponse

- (instancetype)initWithApiResponse:(nullable id)apiResponse {

  self = [super initWithApiResponse:apiResponse];

  if (self) {
    NSDictionary *apiObject = apiResponse; // [super initWithApiResponse:]
                                           // checks that this is nonnull and a
                                           // dictionary
    self.review =
        [[BVSubmittedReview alloc] initWithApiResponse:apiObject[@"Review"]];
  }

  return self;
}

@end
