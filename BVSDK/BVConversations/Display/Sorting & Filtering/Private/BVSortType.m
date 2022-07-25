//
//  BVSortType.m
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
//

#import "BVSortType.h"

@implementation BVSortType

+ (nonnull instancetype)sortTypeWithRawValue:(NSInteger)rawValue {
  NSAssert(NO, @"sortTypeWithRawValue: should be overriden by the subclass");
  return [super init];
}

+ (nonnull NSString *)toSortTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  NSAssert(NO, @"toSortTypeParameterStringWithRawValue: should be "
               @"overriden by the subclass");
  return @"";
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  // Discards the rawValue as this should be overridden and mapped appropriately
  // by the subclass.
  return [super init];
}

- (nonnull NSString *)toSortTypeParameterString {
  NSAssert(NO,
           @"toSortTypeParameterString should be overriden by the subclass");
  return @"";
}

@end
