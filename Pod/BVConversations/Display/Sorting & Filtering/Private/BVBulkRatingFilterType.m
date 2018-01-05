//
//  BVBulkRatingFilterType.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBulkRatingFilterType.h"

@interface BVBulkRatingFilterType ()
@property(nonnull, nonatomic, strong) NSString *value;
@end

@implementation BVBulkRatingFilterType

+ (nonnull NSString *)toFilterTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVBulkRatingFilterType filterTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)filterTypeWithRawValue:(NSInteger)rawValue {
  return [[BVBulkRatingFilterType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVBulkRatingFilterValueBulkRatingContentLocale:
      self.value = @"ContentLocale";
      break;
    case BVBulkRatingFilterValueBulkRatingProductId:
      self.value = @"ProductId";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toFilterTypeParameterString {
  return self.value;
}

- (nonnull instancetype)initWithBulkRatingFilterValue:
    (BVBulkRatingFilterValue)bulkRatingFilterValue {
  return
      [[BVBulkRatingFilterType alloc] initWithRawValue:bulkRatingFilterValue];
}

@end
