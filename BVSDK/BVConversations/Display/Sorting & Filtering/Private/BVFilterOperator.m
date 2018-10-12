//
//  FilterOperator.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFilterOperator.h"

@implementation BVFilterOperator

+ (nonnull instancetype)filterOperatorWithRawValue:(NSInteger)rawValue {
  NSAssert(NO,
           @"filterOperatorWithRawValue: should be overriden by the subclass");
  return [super init];
}

+ (nonnull NSString *)toFilterOperatorParameterStringWithRawValue:
    (NSInteger)rawValue {
  NSAssert(NO, @"toFilterOperatorParameterStringWithRawValue: should be "
               @"overriden by the subclass");
  return @"";
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  // Discards the rawValue as this should be overridden and mapped appropriately
  // by the subclass.
  return [super init];
}

- (nonnull NSString *)toFilterOperatorParameterString {
  NSAssert(NO,
           @"toFilterTypeParameterString should be overriden by the subclass");
  return @"";
}

@end
