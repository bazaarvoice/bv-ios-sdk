//
//  BVSortOrder.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVSortOrder.h"

@implementation BVSortOrder

+ (nonnull instancetype)sortOrderWithRawValue:(NSInteger)rawValue {
  NSAssert(NO, @"sortOrderWithRawValue: should be overriden by the subclass");
  return [super init];
}

+ (nonnull NSString *)toSortOrderParameterStringWithRawValue:
    (NSInteger)rawValue {
  NSAssert(NO, @"toSortOrderParameterStringWithRawValue: should be "
               @"overriden by the subclass");
  return @"";
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  // Discards the rawValue as this should be overridden and mapped appropriately
  // by the subclass.
  return [super init];
}

- (nonnull NSString *)toSortOrderParameterString {
  NSAssert(NO,
           @"toSortOrderParameterString should be overriden by the subclass");
  return @"";
}

@end
