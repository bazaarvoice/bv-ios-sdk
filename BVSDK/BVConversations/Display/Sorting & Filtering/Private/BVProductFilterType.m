//
//  BVProductFilterType.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductFilterType.h"

@interface BVProductFilterType ()
@property(nonnull, nonatomic, readwrite) NSString *value;
@end

@implementation BVProductFilterType

+ (nonnull NSString *)toFilterTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVProductFilterType filterTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)filterTypeWithRawValue:(NSInteger)rawValue {
  return [[BVProductFilterType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVProductFilterValueProductId:
      self.value = @"Id";
      break;
    case BVProductFilterValueProductAverageOverallRating:
      self.value = @"AverageOverallRating";
      break;
    case BVProductFilterValueProductCategoryAncestorId:
      self.value = @"CategoryAncestorId";
      break;
    case BVProductFilterValueProductCategoryId:
      self.value = @"CategoryId";
      break;
    case BVProductFilterValueProductIsActive:
      self.value = @"IsActive";
      break;
    case BVProductFilterValueProductIsDisabled:
      self.value = @"IsDisabled";
      break;
    case BVProductFilterValueProductLastAnswerTime:
      self.value = @"LastAnswerTime";
      break;
    case BVProductFilterValueProductLastQuestionTime:
      self.value = @"LastQuestionTime";
      break;
    case BVProductFilterValueProductLastReviewTime:
      self.value = @"LastReviewTime";
      break;
    case BVProductFilterValueProductLastStoryTime:
      self.value = @"LastStoryTime";
      break;
    case BVProductFilterValueProductName:
      self.value = @"Name";
      break;
    case BVProductFilterValueProductRatingsOnlyReviewCount:
      self.value = @"RatingsOnlyReviewCount";
      break;
    case BVProductFilterValueProductTotalAnswerCount:
      self.value = @"TotalAnswerCount";
      break;
    case BVProductFilterValueProductTotalQuestionCount:
      self.value = @"TotalQuestionCount";
      break;
    case BVProductFilterValueProductTotalReviewCount:
      self.value = @"TotalReviewCount";
      break;
    case BVProductFilterValueProductTotalStoryCount:
      self.value = @"TotalStoryCount";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toFilterTypeParameterString {
  return self.value;
}

- (nonnull instancetype)initWithProductFilterValue:
    (BVProductFilterValue)productFilterValue {
  return [[BVProductFilterType alloc] initWithRawValue:productFilterValue];
}

@end
