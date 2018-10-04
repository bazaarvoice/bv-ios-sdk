//
//  BVAnswerSubmissionErrorResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswerSubmissionErrorResponse.h"
#import "BVNullHelper.h"

@implementation BVAnswerSubmissionErrorResponse

- (instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    if (__IS_KIND_OF(apiResponse, NSDictionary)) {
      NSDictionary *apiObject = (NSDictionary *)apiResponse;
      self.errorResult =
          [[BVSubmittedAnswer alloc] initWithApiResponse:apiObject[@"Answer"]];
    }
  }
  return self;
}

@end
