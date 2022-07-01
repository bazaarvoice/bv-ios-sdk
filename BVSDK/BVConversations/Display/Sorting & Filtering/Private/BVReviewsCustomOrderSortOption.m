#import "BVReviewsCustomOrderSortOption.h"

@interface BVReviewsCustomOrderSortOption ()
@property(nonnull, nonatomic, strong) NSString *value;
@end

@implementation BVReviewsCustomOrderSortOption

+ (nonnull NSString *)toSortOptionParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVReviewsCustomOrderSortOption sortOptionWithRawValue:rawValue].value;
}

+ (nonnull instancetype)sortOptionWithRawValue:(NSInteger)rawValue {
  return [[BVReviewsCustomOrderSortOption alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVReviewsCustomOrderSortOptionValueContentLocale:
      self.value = @"ContentLocale";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toSortOptionParameterString {
  return self.value;
}

- (nonnull instancetype)initWithReviewsSortOptionValue:
    (BVReviewsCustomOrderSortOptionValue)reviewsSortOptionValue {
  return [BVReviewsCustomOrderSortOption sortOptionWithRawValue:reviewsSortOptionValue];
}

@end
