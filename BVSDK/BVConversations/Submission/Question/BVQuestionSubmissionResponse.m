//
//  BVQuestionSubmissionResponse.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionSubmissionResponse.h"

@implementation BVQuestionSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    self.result = [[BVSubmittedQuestion alloc]
        initWithApiResponse:apiResponse[@"Question"]];
  }
  return self;
}

@end
