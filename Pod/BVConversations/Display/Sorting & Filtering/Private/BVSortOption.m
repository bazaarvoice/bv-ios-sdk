//
//  BVSortOption.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVSortOption.h"

@implementation BVSortOption

+ (nonnull instancetype)sortOptionWithRawValue:(NSInteger)rawValue {
  NSAssert(NO, @"sortOptionWithRawValue: should be overriden by the subclass");
  return [super init];
}

+ (nonnull NSString *)toSortOptionParameterStringWithRawValue:
    (NSInteger)rawValue {
  NSAssert(NO, @"toSortOptionParameterStringWithRawValue: should be "
               @"overriden by the subclass");
  return @"";
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  // Discards the rawValue as this should be overridden and mapped appropriately
  // by the subclass.
  return [super init];
}

- (nonnull NSString *)toSortOptionParameterString {
  NSAssert(NO,
           @"toSortOptionParameterString should be overriden by the subclass");
  return @"";
}

@end
