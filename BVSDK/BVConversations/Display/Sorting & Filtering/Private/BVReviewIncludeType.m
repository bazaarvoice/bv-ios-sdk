//
//  BVReviewIncludeType.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVReviewIncludeType.h"

@interface BVReviewIncludeType ()
@property(nonnull, nonatomic, readwrite) NSString *value;
@end

@implementation BVReviewIncludeType

+ (nonnull NSString *)toIncludeTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVReviewIncludeType includeTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)includeTypeWithRawValue:(NSInteger)rawValue {
  return [[BVReviewIncludeType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVReviewIncludeTypeValueReviewProducts:
      self.value = @"Products";
      break;
    case BVReviewIncludeTypeValueReviewComments:
      self.value = @"Comments";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toIncludeTypeParameterString {
  return self.value;
}

- (nonnull instancetype)initWithReviewIncludeTypeValue:
    (BVReviewIncludeTypeValue)reviewIncludeTypeValue {
  return [BVReviewIncludeType includeTypeWithRawValue:reviewIncludeTypeValue];
}

@end
