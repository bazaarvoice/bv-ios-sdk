//
//  BVRelevancySortType.m
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
//

#import "BVRelevancySortType.h"

@interface BVRelevancySortType ()
@property(nonnull, nonatomic, strong) NSString *value;
@end

@implementation BVRelevancySortType

+ (nonnull NSString *)toSortTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVRelevancySortType sortTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)sortTypeWithRawValue:(NSInteger)rawValue {
  return [[BVRelevancySortType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVRelevancySortTypeValueA2:
      self.value = @"A2";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toSortTypeParameterString {
  return self.value;
}

- (nonnull instancetype)initWithRelevancySortTypeValue:
    (BVRelevancySortTypeValue)relevancySortTypeValue {
  return [BVRelevancySortType sortTypeWithRawValue:relevancySortTypeValue];
}

@end
