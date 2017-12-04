//
//  BVSubmittedFeedback.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedFeedback.h"
#import "BVCore.h"

@implementation BVFeedbackInappropriateResponse

- (nullable instancetype)initWithFeedbackResponse:
    (nullable id)inapropriateDict {
  self = [super init];
  if (self) {

    if (inapropriateDict == nil ||
        ![inapropriateDict isKindOfClass:[NSDictionary class]]) {
      return nil;
    }

    NSDictionary *values = [inapropriateDict objectForKey:@"Inappropriate"];

    if (values) {
      SET_IF_NOT_NULL(self.authorId, [values objectForKey:@"AuthorId"]);
      SET_IF_NOT_NULL(self.reasonText, [values objectForKey:@"ReasonText"]);
    } else {
      return nil;
    }
  }
  return self;
}

@end

@implementation BVFeedbackHelpfulnessResponse

- (nullable instancetype)initWithFeedbackResponse:(nullable id)helpfulnessDict {
  self = [super init];
  if (self) {

    if (helpfulnessDict == nil ||
        ![helpfulnessDict isKindOfClass:[NSDictionary class]]) {
      return nil;
    }

    NSDictionary *values = [helpfulnessDict objectForKey:@"Helpfulness"];

    if (values) {
      SET_IF_NOT_NULL(self.authorId, [values objectForKey:@"AuthorId"]);
      SET_IF_NOT_NULL(self.vote, [values objectForKey:@"Vote"]);
    } else {
      return nil;
    }
  }
  return self;
}

@end

@implementation BVSubmittedFeedback

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
  self = [super init];
  if (self) {

    if (apiResponse == nil ||
        ![apiResponse isKindOfClass:[NSDictionary class]]) {
      return nil;
    }

    NSDictionary *apiObject = apiResponse;

    if (apiObject) {
      self.inappropriateResponse = [[BVFeedbackInappropriateResponse alloc]
          initWithFeedbackResponse:apiObject];
      self.helpfulnessResponse = [[BVFeedbackHelpfulnessResponse alloc]
          initWithFeedbackResponse:apiObject];
    } else {
      return nil;
    }
  }
  return self;
}

@end
