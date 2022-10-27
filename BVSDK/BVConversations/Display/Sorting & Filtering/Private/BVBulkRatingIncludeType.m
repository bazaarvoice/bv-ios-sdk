//
//  BVBulkRatingIncludeType.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVBulkRatingIncludeType.h"

@interface BVBulkRatingIncludeType ()
@property(nonnull, nonatomic, readwrite) NSString *value;
@end

@implementation BVBulkRatingIncludeType

+ (nonnull NSString *)toIncludeTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVBulkRatingIncludeType includeTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)includeTypeWithRawValue:(NSInteger)rawValue {
  return [[BVBulkRatingIncludeType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVBulkRatingIncludeTypeValueBulkRatingReviews:
      self.value = @"Reviews";
      break;
    case BVBulkRatingIncludeTypeValueBulkRatingNativeReviews:
      self.value = @"NativeReviews";
      break;
    case BVBulkRatingIncludeTypeValueBulkRatingNativeAnswers:
        self.value = @"Answers";
        break;
    case BVBulkRatingIncludeTypeValueBulkRatingQuestions:
        self.value = @"Questions";
        break;
    case BVBulkRatingIncludeTypeValueBulkRatingAll:
      self.value = @"Reviews,NativeReviews,Answers,Questions";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toIncludeTypeParameterString {
  return self.value;
}

- (nonnull instancetype)initWithBulkRatingIncludeTypeValue:
    (BVBulkRatingIncludeTypeValue)bulkRatingIncludeTypeValue {
  return [BVBulkRatingIncludeType
      includeTypeWithRawValue:bulkRatingIncludeTypeValue];
}

@end
