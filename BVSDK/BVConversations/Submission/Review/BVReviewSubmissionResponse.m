//
//  BVReviewSubmissionResponse.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewSubmissionResponse.h"

@implementation BVReviewSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    self.result =
        [[BVSubmittedReview alloc] initWithApiResponse:apiResponse[@"Review"]];
  }
  return self;
}

@end
