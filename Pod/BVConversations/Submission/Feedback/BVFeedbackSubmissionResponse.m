//
//  BVFeedbackSubmissionResponse.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFeedbackSubmissionResponse.h"
#import "BVSubmittedFeedback.h"

@implementation BVFeedbackSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {

  self = [super initWithApiResponse:apiResponse];

  if (self) {
    self.feedback = [[BVSubmittedFeedback alloc]
        initWithApiResponse:apiResponse[@"Feedback"]];
  }

  return self;
}

@end
