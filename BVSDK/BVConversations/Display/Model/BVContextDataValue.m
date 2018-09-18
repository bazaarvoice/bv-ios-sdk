//
//  ContextDataValue.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVContextDataValue.h"
#import "BVNullHelper.h"

@implementation BVContextDataValue

- (id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  if ((self = [super init])) {
    SET_IF_NOT_NULL(self.value, apiResponse[@"Value"])
    SET_IF_NOT_NULL(self.valueLabel, apiResponse[@"ValueLabel"])
    SET_IF_NOT_NULL(self.dimensionLabel, apiResponse[@"DimensionLabel"])
    SET_IF_NOT_NULL(self.identifier, apiResponse[@"Id"])
  }
  return self;
}

@end
