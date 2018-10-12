//
//  BVSubmittedFeedback.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedFeedback.h"
#import "BVCommon.h"

@implementation BVFeedbackInappropriateResponse

- (nullable instancetype)initWithFeedbackResponse:
    (nullable id)inapropriateDict {
  if ((self = [super init])) {

    if (!__IS_KIND_OF(inapropriateDict, NSDictionary)) {
      return nil;
    }

    NSDictionary *container = (NSDictionary *)inapropriateDict;
    NSDictionary *innerContainer = [container objectForKey:@"Inappropriate"];

    if (!__IS_KIND_OF(innerContainer, NSDictionary)) {
      return nil;
    }

    NSDictionary *values = (NSDictionary *)innerContainer;
    SET_IF_NOT_NULL(self.authorId, [values objectForKey:@"AuthorId"]);
    SET_IF_NOT_NULL(self.reasonText, [values objectForKey:@"ReasonText"]);
  }
  return self;
}

@end

@implementation BVFeedbackHelpfulnessResponse

- (nullable instancetype)initWithFeedbackResponse:(nullable id)helpfulnessDict {
  if ((self = [super init])) {

    if (!__IS_KIND_OF(helpfulnessDict, NSDictionary)) {
      return nil;
    }

    NSDictionary *container = (NSDictionary *)helpfulnessDict;
    NSDictionary *innerContainer = [container objectForKey:@"Helpfulness"];

    if (!__IS_KIND_OF(innerContainer, NSDictionary)) {
      return nil;
    }

    NSDictionary *values = (NSDictionary *)innerContainer;
    SET_IF_NOT_NULL(self.authorId, [values objectForKey:@"AuthorId"]);
    SET_IF_NOT_NULL(self.vote, [values objectForKey:@"Vote"]);
  }
  return self;
}

@end

@implementation BVSubmittedFeedback

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {

    if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;
    self.inappropriateResponse = [[BVFeedbackInappropriateResponse alloc]
        initWithFeedbackResponse:apiObject];
    self.helpfulnessResponse = [[BVFeedbackHelpfulnessResponse alloc]
        initWithFeedbackResponse:apiObject];
  }
  return self;
}

@end
