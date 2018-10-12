//
//  BVProductsSortOption.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductsSortOption.h"

@interface BVProductsSortOption ()
@property(nonnull, nonatomic, strong) NSString *value;
@end

@implementation BVProductsSortOption

+ (nonnull NSString *)toSortOptionParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVProductsSortOption sortOptionWithRawValue:rawValue].value;
}

+ (nonnull instancetype)sortOptionWithRawValue:(NSInteger)rawValue {
  return [[BVProductsSortOption alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVProductsSortOptionValueProductId:
      self.value = @"Id";
      break;
    case BVProductsSortOptionValueProductAverageOverallRating:
      self.value = @"AverageOverallRating";
      break;
    case BVProductsSortOptionValueProductRating:
      self.value = @"Rating";
      break;
    case BVProductsSortOptionValueProductCategoryId:
      self.value = @"CategoryId";
      break;
    case BVProductsSortOptionValueProductIsActive:
      self.value = @"IsActive";
      break;
    case BVProductsSortOptionValueProductIsDisabled:
      self.value = @"IsDisabled";
      break;
    case BVProductsSortOptionValueProductLastAnswerTime:
      self.value = @"LastAnswerTime";
      break;
    case BVProductsSortOptionValueProductLastQuestionTime:
      self.value = @"LastQuestionTime";
      break;
    case BVProductsSortOptionValueProductLastReviewTime:
      self.value = @"LastReviewTime";
      break;
    case BVProductsSortOptionValueProductLastStoryTime:
      self.value = @"LastStoryTime";
      break;
    case BVProductsSortOptionValueProductName:
      self.value = @"Name";
      break;
    case BVProductsSortOptionValueProductRatingsOnlyReviewCount:
      self.value = @"RatingsOnlyReviewCount";
      break;
    case BVProductsSortOptionValueProductTotalAnswerCount:
      self.value = @"TotalAnswerCount";
      break;
    case BVProductsSortOptionValueProductTotalQuestionCount:
      self.value = @"TotalQuestionCount";
      break;
    case BVProductsSortOptionValueProductTotalReviewCount:
      self.value = @"TotalReviewCount";
      break;
    case BVProductsSortOptionValueProductTotalStoryCount:
      self.value = @"TotalStoryCount";
      break;
    case BVProductsSortOptionValueProductHelpfulness:
      self.value = @"Helpfulness";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toSortOptionParameterString {
  return self.value;
}

- (nonnull instancetype)initWithProductsSortOptionValue:
    (BVProductsSortOptionValue)productsSortOptionValue {
  return [BVProductsSortOption sortOptionWithRawValue:productsSortOptionValue];
}

@end
