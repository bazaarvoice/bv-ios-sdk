//
//  BVSyndicationSource.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSyndicationSource.h"
#import "BVNullHelper.h"

@implementation BVSyndicationSource

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  self = [super init];
  if (self) {
    if (apiResponse == nil ||
        ![apiResponse isKindOfClass:[NSDictionary class]]) {
      return nil;
    }

    NSDictionary *apiObject = [apiResponse objectForKey:@"SyndicationSource"];

    if (apiObject) {
      SET_IF_NOT_NULL(_name, apiObject[@"Name"]);
      SET_IF_NOT_NULL(_contentLink, apiObject[@"ContentLink"]);
      SET_IF_NOT_NULL(_logoImageUrl, apiObject[@"LogoImageUrl"]);
    }
  }
  return self;
}

@end
