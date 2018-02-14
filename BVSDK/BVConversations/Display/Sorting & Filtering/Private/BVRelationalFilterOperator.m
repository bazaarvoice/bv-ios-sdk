//
//  BVRelationalFilterOperator.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVRelationalFilterOperator.h"

@interface BVRelationalFilterOperator ()
@property(nonnull, nonatomic, strong) NSString *value;
@end

@implementation BVRelationalFilterOperator

+ (nonnull NSString *)toFilterOperatorParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVRelationalFilterOperator filterOperatorWithRawValue:rawValue].value;
}

+ (nonnull instancetype)filterOperatorWithRawValue:(NSInteger)rawValue {
  return [[BVRelationalFilterOperator alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVRelationalFilterOperatorValueGreaterThan:
      self.value = @"gt";
      break;
    case BVRelationalFilterOperatorValueGreaterThanOrEqualTo:
      self.value = @"gte";
      break;
    case BVRelationalFilterOperatorValueLessThan:
      self.value = @"lt";
      break;
    case BVRelationalFilterOperatorValueLessThanOrEqualTo:
      self.value = @"lte";
      break;
    case BVRelationalFilterOperatorValueEqualTo:
      self.value = @"eq";
      break;
    case BVRelationalFilterOperatorValueNotEqualTo:
      self.value = @"neq";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toFilterOperatorParameterString {
  return self.value;
}

- (nonnull instancetype)initWithRelationalFilterValue:
    (BVRelationalFilterOperatorValue)relationalFilterValue {
  return [BVRelationalFilterOperator
      filterOperatorWithRawValue:relationalFilterValue];
}

@end
