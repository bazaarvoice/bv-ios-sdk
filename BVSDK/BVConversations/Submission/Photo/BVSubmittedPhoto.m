//
//  BVSubmittedPhoto.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedPhoto.h"
#import "BVNullHelper.h"

@implementation BVSubmittedPhoto

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {

    if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;
    self.photo = [[BVPhoto alloc] initWithApiResponse:apiObject];
  }
  return self;
}

@end
