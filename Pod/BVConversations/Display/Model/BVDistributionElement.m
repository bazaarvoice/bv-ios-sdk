//
//  DistributionElement.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDistributionElement.h"
#import "BVNullHelper.h"

@implementation BVDistributionElement

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  self = [super init];
  if (self) {
    SET_IF_NOT_NULL(self.label, apiResponse[@"Label"])
    SET_IF_NOT_NULL(self.identifier, apiResponse[@"Id"])

    NSMutableArray *tempValues = [NSMutableArray array];
    for (NSDictionary *value in apiResponse[@"Values"]) {
      BVDistributionValue *distributionValue =
          [[BVDistributionValue alloc] initWithApiResponse:value];
      [tempValues addObject:distributionValue];
    }
    self.values = tempValues;
  }
  return self;
}

@end
