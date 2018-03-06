//
//  SecondaryRating.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSecondaryRating.h"
#import "BVNullHelper.h"

@implementation BVSecondaryRating

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  self = [super init];
  if (self) {
    SET_IF_NOT_NULL(self.value, apiResponse[@"Value"])
    SET_IF_NOT_NULL(self.valueLabel, apiResponse[@"ValueLabel"])
    SET_IF_NOT_NULL(self.maxLabel, apiResponse[@"MaxLabel"])
    SET_IF_NOT_NULL(self.label, apiResponse[@"Label"])
    SET_IF_NOT_NULL(self.identifier, apiResponse[@"Id"])
    SET_IF_NOT_NULL(self.valueRange, apiResponse[@"ValueRange"])
    SET_IF_NOT_NULL(self.minLabel, apiResponse[@"MinLabel"])
    SET_IF_NOT_NULL(self.displayType, apiResponse[@"DisplayType"])
  }
  return self;
}

@end
