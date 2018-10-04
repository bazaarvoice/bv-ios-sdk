//
//  DistributionValue.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDistributionValue.h"
#import "BVNullHelper.h"

@implementation BVDistributionValue

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  if ((self = [super init])) {
    SET_IF_NOT_NULL(self.value, apiResponse[@"Value"])
    SET_IF_NOT_NULL(self.count, apiResponse[@"Count"])
  }
  return self;
}

@end
