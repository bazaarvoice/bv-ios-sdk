//
//  DimensionElement.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDimensionElement.h"
#import "BVNullHelper.h"

@implementation BVDimensionElement

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  if ((self = [super init])) {
    SET_IF_NOT_NULL(self.identifier, apiResponse[@"Id"])
    SET_IF_NOT_NULL(self.label, apiResponse[@"Label"])
    SET_IF_NOT_NULL(self.values, apiResponse[@"Values"])
  }
  return self;
}

@end
