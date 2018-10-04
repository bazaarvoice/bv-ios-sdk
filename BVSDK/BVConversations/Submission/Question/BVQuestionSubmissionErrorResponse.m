//
//  BVQuestionSubmissionErrorResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionSubmissionErrorResponse.h"
#import "BVNullHelper.h"

@implementation BVQuestionSubmissionErrorResponse

- (instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    if (__IS_KIND_OF(apiResponse, NSDictionary)) {
      NSDictionary *apiObject = (NSDictionary *)apiResponse;
      self.errorResult = [[BVSubmittedQuestion alloc]
          initWithApiResponse:apiObject[@"Question"]];
    }
  }
  return self;
}

@end
