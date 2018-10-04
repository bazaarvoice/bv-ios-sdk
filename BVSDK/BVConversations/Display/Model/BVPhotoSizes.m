//
//  PhotoSizes.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVPhotoSizes.h"
#import "BVNullHelper.h"

@implementation BVPhotoSizes

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {

    if (!apiResponse) {
      return nil;
    }

    NSDictionary<NSString *, NSDictionary<NSString *, NSString *> *>
        *apiObject =
            (NSDictionary<NSString *, NSDictionary<NSString *, NSString *> *> *)
                apiResponse;

    if (!isObjectNilOrNull(apiObject[@"thumbnail"][@"Url"])) {
      self.thumbnailUrl = apiObject[@"thumbnail"][@"Url"];
    }

    if (!isObjectNilOrNull(apiObject[@"normal"][@"Url"])) {
      self.normalUrl = apiObject[@"normal"][@"Url"];
    }
  }
  return self;
}

@end
