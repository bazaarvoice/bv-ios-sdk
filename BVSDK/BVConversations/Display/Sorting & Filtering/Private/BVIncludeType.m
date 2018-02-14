//
//  BVIncludeType.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVIncludeType.h"

@implementation BVIncludeType

+ (nonnull instancetype)includeTypeWithRawValue:(NSInteger)rawValue {
  NSAssert(NO, @"includeTypeWithRawValue: should be overriden by the subclass");
  return [super init];
}

+ (nonnull NSString *)toIncludeTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  NSAssert(NO, @"toIncludeTypeParameterStringWithRawValue: should be overriden "
               @"by the subclass");
  return @"";
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  // Discards the rawValue as this should be overridden and mapped appropriately
  // by the subclass.
  return [super init];
}

- (nonnull NSString *)toIncludeTypeParameterString {
  NSAssert(NO,
           @"toIncludeTypeParameterString should be overriden by the subclass");
  return @"";
}

@end
