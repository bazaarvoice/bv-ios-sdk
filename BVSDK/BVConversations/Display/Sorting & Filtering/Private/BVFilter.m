//
//  Filters.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFilter.h"
#import "BVCommaUtil.h"

@interface BVFilter ()

@property(nonnull) NSString *filterType;
@property(nonnull) NSString *filterOp;
@property(nonnull) NSArray<NSString *> *values;

@end

@implementation BVFilter

- (nonnull id)initWithFilterType:(nonnull id<BVFilterTypeProtocol>)filterType
                  filterOperator:
                      (nonnull id<BVFilterOperatorProtocol>)filterOperator
                           value:(nonnull NSString *)value {
  if ((self = [super init])) {
    self.filterType = [filterType toFilterTypeParameterString];
    self.filterOp = [filterOperator toFilterOperatorParameterString];
    self.values = [BVCommaUtil escapeMultiple:@[ value ]];
  }
  return self;
}

- (nonnull id)initWithFilterType:(nonnull id<BVFilterTypeProtocol>)filterType
                  filterOperator:
                      (nonnull id<BVFilterOperatorProtocol>)filterOperator
                          values:(nonnull NSArray<NSString *> *)values {
  if ((self = [super init])) {
    self.filterType = [filterType toFilterTypeParameterString];
    self.filterOp = [filterOperator toFilterOperatorParameterString];
    self.values = [BVCommaUtil escapeMultiple:values];
  }
  return self;
}

- (nonnull id)initWithString:(nonnull NSString *)str
              filterOperator:
                  (nonnull id<BVFilterOperatorProtocol>)filterOperator
                      values:(nonnull NSArray<NSString *> *)values {
  if ((self = [super init])) {
    self.filterType = str;
    self.filterOp = [filterOperator toFilterOperatorParameterString];
    self.values = [BVCommaUtil escapeMultiple:values];
  }
  return self;
}

- (NSString *)toParameterString {
  NSString *start = self.filterType;
  NSString *middle = self.filterOp;
  NSArray<NSString *> *sortedArray = [self.values
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
  NSString *end = [sortedArray componentsJoinedByString:@","];

  return [NSString stringWithFormat:@"%@:%@:%@", start, middle, end];
}

@end
