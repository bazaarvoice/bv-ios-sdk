//
//  BVFeedbackSubmissionErrorResponse.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVFeedbackSubmissionErrorResponse.h"
#import "BVNullHelper.h"

@implementation BVFeedbackSubmissionErrorResponse

- (instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    if (__IS_KIND_OF(apiResponse, NSDictionary)) {
      NSDictionary *apiObject = (NSDictionary *)apiResponse;
      self.errorResult = [[BVSubmittedFeedback alloc]
          initWithApiResponse:apiObject[@"Feedback"]];
    }
  }
  return self;
}

@end
