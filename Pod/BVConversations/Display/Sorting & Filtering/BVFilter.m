//
//  Filters.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFilter.h"
#import "BVCommaUtil.h"

@interface BVFilter ()

@property(nonnull) NSString *type;
@property BVFilterOperator filterOperator;
@property(nonnull) NSArray<NSString *> *values;

@end

@implementation BVFilter

- (nonnull id)initWithType:(BVProductFilterType)type
            filterOperator:(BVFilterOperator)filterOperator
                    values:(nonnull NSArray<NSString *> *)values {
  self = [super init];
  if (self) {
    self.type = [BVProductFilterTypeUtil toString:type];
    self.filterOperator = filterOperator;
    self.values = [BVCommaUtil escapeMultiple:values];
  }
  return self;
}

- (nonnull id)initWithType:(BVProductFilterType)type
            filterOperator:(BVFilterOperator)filterOperator
                     value:(nonnull NSString *)value {
  self = [super init];
  if (self) {
    self.type = [BVProductFilterTypeUtil toString:type];
    self.filterOperator = filterOperator;
    self.values = [BVCommaUtil escapeMultiple:@[ value ]];
  }
  return self;
}

- (nonnull id)initWithString:(nonnull NSString *)str
              filterOperator:(BVFilterOperator)filterOperator
                      values:(nonnull NSArray<NSString *> *)values {
  self = [super init];
  if (self) {
    self.type = str;
    self.filterOperator = filterOperator;
    self.values = [BVCommaUtil escapeMultiple:values];
  }
  return self;
}

- (NSString *)toParameterString {
  NSString *start = self.type;
  NSString *middle = [BVFilterOperatorUtil toString:self.filterOperator];
  NSArray<NSString *> *sortedArray = [self.values
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
  NSString *end = [sortedArray componentsJoinedByString:@","];

  return [NSString stringWithFormat:@"%@:%@:%@", start, middle, end];
}

@end
