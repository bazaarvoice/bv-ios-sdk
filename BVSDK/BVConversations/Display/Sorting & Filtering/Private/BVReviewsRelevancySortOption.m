//
//  BVReviewsRelevancySortOption.m
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

#import "BVReviewsRelevancySortOption.h"

@interface BVReviewsRelevancySortOption ()
@property(nonnull, nonatomic, strong) NSString *value;
@end

@implementation BVReviewsRelevancySortOption

+ (nonnull NSString *)toSortOptionParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVReviewsRelevancySortOption sortOptionWithRawValue:rawValue].value;
}

+ (nonnull instancetype)sortOptionWithRawValue:(NSInteger)rawValue {
  return [[BVReviewsRelevancySortOption alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVReviewsRelevancySortOptionValueRelevancy:
      self.value = @"Relevancy";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toSortOptionParameterString {
  return self.value;
}

- (nonnull instancetype)initWithReviewsRelevancySortOptionValue:
    (BVReviewsRelevancySortOptionValue)reviewsRelevancySortOptionValue {
  return [BVReviewsRelevancySortOption sortOptionWithRawValue:reviewsRelevancySortOptionValue];
}


@end
