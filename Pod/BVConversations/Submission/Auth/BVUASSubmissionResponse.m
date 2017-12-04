//
//  BVUASSubmissionResponse.m
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVUASSubmissionResponse.h"
#import "BVSubmittedUAS.h"

@interface BVUASSubmissionResponse ()
@property(nullable, strong, nonatomic, readwrite)
    BVSubmittedUAS *userAuthenticationString;
@end

@implementation BVUASSubmissionResponse

- (nullable BVSubmittedUAS *)userAuthenticationString {
  return self.userAuthenticationString;
}

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    self.userAuthenticationString = [[BVSubmittedUAS alloc]
        initWithApiResponse:apiResponse[@"Authentication"]];
  }

  return self;
}

@end
