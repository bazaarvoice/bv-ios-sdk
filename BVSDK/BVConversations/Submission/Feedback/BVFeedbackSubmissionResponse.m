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
  if ((self = [super initWithApiResponse:apiResponse])) {
    self.result = [[BVSubmittedFeedback alloc]
        initWithApiResponse:apiResponse[@"Feedback"]];
  }
  return self;
}

@end
