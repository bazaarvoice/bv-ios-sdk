//
//  BVAnswerSubmissionResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswerSubmissionResponse.h"

@implementation BVAnswerSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {

  self = [super initWithApiResponse:apiResponse];

  if (self) {
    self.answer =
        [[BVSubmittedAnswer alloc] initWithApiResponse:apiResponse[@"Answer"]];
  }

  return self;
}

@end
