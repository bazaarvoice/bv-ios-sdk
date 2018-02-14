//
//  BVAuthorIncludeType.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVAuthorIncludeType.h"

@interface BVAuthorIncludeType ()
@property(nonnull, nonatomic, readwrite) NSString *value;
@end

@implementation BVAuthorIncludeType

+ (nonnull NSString *)toIncludeTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVAuthorIncludeType includeTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)includeTypeWithRawValue:(NSInteger)rawValue {
  return [[BVAuthorIncludeType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVAuthorIncludeTypeValueAuthorReviews:
      self.value = @"Reviews";
      break;
    case BVAuthorIncludeTypeValueAuthorAnswers:
      self.value = @"Answers";
      break;
    case BVAuthorIncludeTypeValueAuthorQuestions:
      self.value = @"Questions";
      break;
    case BVAuthorIncludeTypeValueAuthorReviewComments:
      self.value = @"Comments";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toIncludeTypeParameterString {
  return self.value;
}

- (nonnull instancetype)initWithAuthorIncludeTypeValue:
    (BVAuthorIncludeTypeValue)authorIncludeTypeValue {
  return [BVAuthorIncludeType includeTypeWithRawValue:authorIncludeTypeValue];
}

@end
