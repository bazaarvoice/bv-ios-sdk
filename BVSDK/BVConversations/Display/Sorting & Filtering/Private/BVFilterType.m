//
//  BVFilterType.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVFilterType.h"

@implementation BVFilterType

+ (nonnull instancetype)filterTypeWithRawValue:(NSInteger)rawValue {
  NSAssert(NO, @"filterTypeWithRawValue: should be overriden by the subclass");
  return [super init];
}

+ (nonnull NSString *)toFilterTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  NSAssert(NO, @"toFilterTypeParameterStringWithRawValue: should be overriden "
               @"by the subclass");
  return @"";
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  // Discards the rawValue as this should be overridden and mapped appropriately
  // by the subclass.
  return [super init];
}

- (nonnull NSString *)toFilterTypeParameterString {
  NSAssert(NO,
           @"toFilterTypeParameterString should be overriden by the subclass");
  return @"";
}

@end
