//
//  BVAnswerSubmissionResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswerSubmissionResponse.h"

@implementation BVAnswerSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    self.result =
        [[BVSubmittedAnswer alloc] initWithApiResponse:apiResponse[@"Answer"]];
  }
  return self;
}

@end
