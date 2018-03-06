//
//  BVProductIncludeType.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVProductIncludeType.h"

@interface BVProductIncludeType ()
@property(nonnull, nonatomic, readwrite) NSString *value;
@end

@implementation BVProductIncludeType

+ (nonnull NSString *)toIncludeTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVProductIncludeType includeTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)includeTypeWithRawValue:(NSInteger)rawValue {
  return [[BVProductIncludeType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVProductIncludeTypeValueReviews:
      self.value = @"Reviews";
      break;
    case BVProductIncludeTypeValueAnswers:
      self.value = @"Answers";
      break;
    case BVProductIncludeTypeValueQuestions:
      self.value = @"Questions";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toIncludeTypeParameterString {
  return self.value;
}

- (nonnull instancetype)initWithPDPIncludeTypeValue:
    (BVProductIncludeTypeValue)pdpIncludeTypeValue {
  return [BVProductIncludeType includeTypeWithRawValue:pdpIncludeTypeValue];
}

@end
