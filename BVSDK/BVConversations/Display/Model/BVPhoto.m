//
//  Photo.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVPhoto.h"
#import "BVNullHelper.h"

@implementation BVPhoto

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {

    if (!apiResponse) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;
    SET_IF_NOT_NULL(self.caption, apiObject[@"Caption"])
    SET_IF_NOT_NULL(self.identifier, apiObject[@"Id"])
    self.sizes = [[BVPhotoSizes alloc] initWithApiResponse:apiObject[@"Sizes"]];
  }
  return self;
}

@end
