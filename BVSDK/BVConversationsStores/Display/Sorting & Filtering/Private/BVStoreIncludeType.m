//
//  BVStoreIncludeType.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVStoreIncludeType.h"

@interface BVStoreIncludeType ()
@property(nonnull, nonatomic, readwrite) NSString *value;
@end

@implementation BVStoreIncludeType

+ (nonnull NSString *)toIncludeTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVStoreIncludeType includeTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)includeTypeWithRawValue:(NSInteger)rawValue {
  return [[BVStoreIncludeType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVStoreIncludeTypeValueReviews:
      self.value = @"Reviews";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toIncludeTypeParameterString {
  return self.value;
}

- (nonnull instancetype)initWithStoreIncludeTypeValue:
    (BVStoreIncludeTypeValue)storeIncludeTypeValue {
  return [BVStoreIncludeType includeTypeWithRawValue:storeIncludeTypeValue];
}

@end
