//
//  BVPDPIncludeType.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVPDPIncludeType.h"

@interface BVPDPIncludeType ()
@property(nonnull, nonatomic, readwrite) NSString *value;
@end

@implementation BVPDPIncludeType

+ (nonnull NSString *)toIncludeTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVPDPIncludeType includeTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)includeTypeWithRawValue:(NSInteger)rawValue {
  return [[BVPDPIncludeType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVPDPIncludeTypeValuePDPReviews:
      self.value = @"Reviews";
      break;
    case BVPDPIncludeTypeValuePDPAnswers:
      self.value = @"Answers";
      break;
    case BVPDPIncludeTypeValuePDPQuestions:
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
    (BVPDPIncludeTypeValue)pdpIncludeTypeValue {
  return [BVPDPIncludeType includeTypeWithRawValue:pdpIncludeTypeValue];
}

@end
