//
//  BVUASSubmission.m
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVUASSubmission.h"
#import "BVCommon.h"
#import "BVSubmission+Private.h"
#import "BVUASSubmissionErrorResponse.h"
#import "BVUASSubmissionResponse.h"

@interface BVUASSubmission ()
@property(nonnull, strong, nonatomic, readwrite) NSString *bvAuthToken;
@end

@implementation BVUASSubmission

- (nonnull instancetype)initWithBvAuthToken:(nonnull NSString *)bvAuthToken {
  if ((self = [super init])) {
    self.bvAuthToken = bvAuthToken ?: @"";
  }
  return self;
}

- (nonnull NSString *)endpoint {
  return @"authenticateuser.json";
}

- (nonnull NSDictionary *)createSubmissionParameters {
  NSMutableDictionary *parameters = [NSMutableDictionary
      dictionaryWithDictionary:[super createSubmissionParameters]];
  parameters[@"authtoken"] = self.bvAuthToken;
  return parameters;
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
  return [[BVUASSubmissionResponse alloc] initWithApiResponse:raw];
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse:
    (nonnull NSDictionary *)raw {
  return [[BVUASSubmissionErrorResponse alloc] initWithApiResponse:raw];
}

- (nullable id<BVAnalyticEvent>)trackEvent {
  return nil;
}

@end
