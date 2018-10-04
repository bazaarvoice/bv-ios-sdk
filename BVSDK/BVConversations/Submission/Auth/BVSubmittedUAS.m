//
//  BVSubmittedUAS.m
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedUAS.h"
#import "BVNullHelper.h"

@interface BVSubmittedUAS ()
@property(nullable, strong, nonatomic, readwrite) NSString *authenticatedUser;
@end

@implementation BVSubmittedUAS

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {
    if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;
    SET_IF_NOT_NULL(self.authenticatedUser, apiObject[@"User"])
  }
  return self;
}

@end
