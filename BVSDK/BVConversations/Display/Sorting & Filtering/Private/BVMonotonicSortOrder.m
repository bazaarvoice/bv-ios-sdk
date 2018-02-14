//
//  BVMonotonicSortOrder.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVMonotonicSortOrder.h"

@interface BVMonotonicSortOrder ()
@property(nonnull, nonatomic, strong) NSString *value;
@end

@implementation BVMonotonicSortOrder

+ (nonnull NSString *)toSortOrderParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVMonotonicSortOrder sortOrderWithRawValue:rawValue].value;
}

+ (nonnull instancetype)sortOrderWithRawValue:(NSInteger)rawValue {
  return [[BVMonotonicSortOrder alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVMonotonicSortOrderValueAscending:
      self.value = @"asc";
      break;
    case BVMonotonicSortOrderValueDescending:
      self.value = @"desc";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toSortOrderParameterString {
  return self.value;
}

- (nonnull instancetype)initWithMonotonicSortOrderValue:
    (BVMonotonicSortOrderValue)monotonicSortOrderValue {
  return [BVMonotonicSortOrder sortOrderWithRawValue:monotonicSortOrderValue];
}

@end
