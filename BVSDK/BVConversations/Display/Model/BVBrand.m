//
//  Brand.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBrand.h"
#import "BVNullHelper.h"

@implementation BVBrand

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {
    if (![apiResponse isKindOfClass:[NSDictionary class]]) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.name, apiObject[@"Name"])
    SET_IF_NOT_NULL(self.identifier, apiObject[@"Id"])
  }
  return self;
}

@end
