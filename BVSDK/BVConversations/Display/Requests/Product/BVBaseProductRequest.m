

//
//  BVBaseProductRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBaseProductRequest+Private.h"
#import "BVConversationsRequest+Private.h"
#import "BVMonotonicSortOrder.h"
#import "BVProductIncludeType.h"
#import "BVQuestionFilterType.h"
#import "BVQuestionsSortOption.h"
#import "BVRelationalFilterOperator.h"
#import "BVReviewFilterType.h"
#import "BVReviewsSortOption.h"
#import "BVStringKeyValuePair.h"

@interface BVBaseProductRequest ()

@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<BVFilter *> *reviewFilters;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<BVFilter *> *questionFilters;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<BVInclude *> *pdpIncludes;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<BVInclude *> *includes;

@end

@implementation BVBaseProductRequest

- (instancetype)init {
  if ((self = [super init])) {
    _includes = [NSMutableArray array];
    _reviewFilters = [NSMutableArray array];
    _questionFilters = [NSMutableArray array];
    _pdpIncludes = [NSMutableArray array];
    self.incentivizedStats = NO;
  }

  return self;
}

- (nonnull NSString *)includesToParams:
    (nonnull NSArray<BVInclude *> *)includes {
  NSMutableArray<NSString *> *strings = [NSMutableArray array];

  for (BVInclude *include in includes) {
    [strings addObject:[include toParameterString]];
  }

  NSArray<NSString *> *sortedArray = [strings
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

  return [sortedArray componentsJoinedByString:@","];
}

- (nonnull NSString *)statisticsToParams:
    (nonnull NSArray<BVInclude *> *)statistics {
  NSMutableArray *strings = [NSMutableArray array];

  for (BVInclude *stat in statistics) {
    [strings addObject:[stat toParameterString]];
  }

  NSArray<NSString *> *sortedArray = [strings
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

  return [sortedArray componentsJoinedByString:@","];
}

- (nonnull NSString *)endpoint {
  return @"products.json";
}

- (nonnull instancetype)includeProductIncludeTypeValue:
                            (BVProductIncludeTypeValue)productIncludeTypeValue
                                                 limit:(NSUInteger)limit {
  BVInclude *include = [[BVInclude alloc]
      initWithIncludeType:[BVProductIncludeType
                              includeTypeWithRawValue:productIncludeTypeValue]
             includeLimit:@(limit)];

  [self.includes addObject:include];
  return self;
}

- (nonnull instancetype)includeStatistics:
    (BVProductIncludeTypeValue)productIncludeTypeValue {

  BVInclude *statToInclude = [[BVInclude alloc]
      initWithIncludeType:[BVProductIncludeType
                              includeTypeWithRawValue:productIncludeTypeValue]];

  [self.pdpIncludes addObject:statToInclude];
  return self;
}

- (nonnull instancetype)
    filterOnReviewFilterValue:(BVReviewFilterValue)reviewFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value {
  BVReviewFilterType *includedReviewsFilterType =
      [BVReviewFilterType filterTypeWithRawValue:reviewFilterValue];

  BVRelationalFilterOperator *relationalFilterOperator =
      [BVRelationalFilterOperator
          filterOperatorWithRawValue:relationalFilterOperatorValue];

  [self addIncludedReviewsFilterType:includedReviewsFilterType
            relationalFilterOperator:relationalFilterOperator
                               value:value];

  return self;
}

- (nonnull instancetype)
addIncludedReviewsFilterType:
    (nonnull BVReviewFilterType *)includedReviewsFilterType
    relationalFilterOperator:
        (nonnull BVFilterOperator *)relationalFilterOperator
                       value:(nonnull NSString *)value {
  BVFilter *filter =
      [[BVFilter alloc] initWithFilterType:includedReviewsFilterType
                            filterOperator:relationalFilterOperator
                                    values:@[ value ]];

  [self.reviewFilters addObject:filter];
  return self;
}

- (nonnull instancetype)
  filterOnQuestionFilterValue:(BVQuestionFilterValue)questionFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value {

  BVQuestionFilterType *includedQuestionsFilterType =
      [BVQuestionFilterType filterTypeWithRawValue:questionFilterValue];

  BVRelationalFilterOperator *relationalFilterOperator =
      [BVRelationalFilterOperator
          filterOperatorWithRawValue:relationalFilterOperatorValue];

  [self addIncludedQuestionsFilterType:includedQuestionsFilterType
              relationalFilterOperator:relationalFilterOperator
                                 value:value];

  return self;
}

- (nonnull instancetype)
addIncludedQuestionsFilterType:
    (nonnull BVQuestionFilterType *)includedQuestionsFilterType
      relationalFilterOperator:
          (nonnull BVFilterOperator *)relationalFilterOperator
                         value:(nonnull NSString *)value {
  BVFilter *filter =
      [[BVFilter alloc] initWithFilterType:includedQuestionsFilterType
                            filterOperator:relationalFilterOperator
                                    values:@[ value ]];

  [self.questionFilters addObject:filter];
  return self;
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];

  for (BVFilter *filter in self.reviewFilters) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Filter_Reviews"
                                value:[filter toParameterString]]];
  }

  for (BVFilter *filter in self.questionFilters) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Filter_Questions"
                                value:[filter toParameterString]]];
  }

  if (0 < self.includes.count) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Include"
                                value:[self includesToParams:self.includes]]];
  }

  NSString *pcts = [self statisticsToParams:self.pdpIncludes];
  if (pcts && pcts.length > 0) {
    [params
        addObject:[BVStringKeyValuePair
                      pairWithKey:@"Stats"
                            value:[self statisticsToParams:self.pdpIncludes]]];
  }

  for (BVInclude *include in self.includes) {
    if (include.includeLimit) {
      NSString *key =
          [NSString stringWithFormat:@"Limit_%@", [include toParameterString]];
      BVStringKeyValuePair *pair = [BVStringKeyValuePair
          pairWithKey:key
                value:[NSString stringWithFormat:@"%@", include.includeLimit]];
      [params addObject:pair];
    }
  }
  
  if (self.incentivizedStats == YES) {
    [params addObject:[BVStringKeyValuePair pairWithKey:@"incentivizedstats" value:@"true"]];
  }

  return params;
}

@end

@interface BVBaseSortableProductRequest ()

@property(nonnull) NSMutableArray<BVSort *> *reviewSorts;
@property(nonnull) NSMutableArray<BVSort *> *questionSorts;
@property(nonnull) NSMutableArray<BVSort *> *answerSorts;

@end

@implementation BVBaseProductsRequest

- (void)load:(ProductSearchRequestCompletionHandler)success
     failure:(ConversationsFailureHandler)failure {
  [self loadContent:self
         completion:^(NSDictionary *__nonnull response) {
           BVBulkProductResponse *productsResponse =
               [[BVBulkProductResponse alloc] initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             success(productsResponse);
           });

         }
            failure:failure];
}

@end

@implementation BVBaseSortableProductRequest

- (instancetype)init {
  if ((self = [super init])) {
    self.reviewSorts = [NSMutableArray array];
    self.questionSorts = [NSMutableArray array];
    self.answerSorts = [NSMutableArray array];
  }

  return self;
}

- (void)load:(ProductSearchRequestCompletionHandler)success
     failure:(ConversationsFailureHandler)failure {
  [self loadContent:self
         completion:^(NSDictionary *__nonnull response) {
           BVBulkProductResponse *productsResponse =
               [[BVBulkProductResponse alloc] initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             success(productsResponse);
           });

         }
            failure:failure];
}

- (nonnull BVStringKeyValuePair *)sortParams:(nonnull NSArray<BVSort *> *)sorts
                                     withKey:(NSString *)paramKey {
  NSMutableArray *strings = [NSMutableArray array];

  for (BVSort *sort in sorts) {
    [strings addObject:[sort toParameterString]];
  }

  NSString *combined = [strings componentsJoinedByString:@","];

  return [BVStringKeyValuePair pairWithKey:paramKey value:combined];
}

- (nonnull instancetype)
sortByReviewsSortOptionValue:(BVReviewsSortOptionValue)reviewsSortOptionValue
     monotonicSortOrderValue:
         (BVMonotonicSortOrderValue)monotonicSortOrderValue {
  BVSort *sort = [[BVSort alloc]
      initWithSortOption:[BVReviewsSortOption
                             sortOptionWithRawValue:reviewsSortOptionValue]
               sortOrder:[BVMonotonicSortOrder
                             sortOrderWithRawValue:monotonicSortOrderValue]];
  [self.reviewSorts addObject:sort];
  return self;
}

- (nonnull instancetype)sortByQuestionsSortOptionValue:
                            (BVQuestionsSortOptionValue)questionsSortOptionValue
                               monotonicSortOrderValue:
                                   (BVMonotonicSortOrderValue)
                                       monotonicSortOrderValue {
  BVSort *sort = [[BVSort alloc]
      initWithSortOption:[BVQuestionsSortOption
                             sortOptionWithRawValue:questionsSortOptionValue]
               sortOrder:[BVMonotonicSortOrder
                             sortOrderWithRawValue:monotonicSortOrderValue]];
  [self.questionSorts addObject:sort];
  return self;
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];

  if (0 < self.reviewSorts.count) {
    [params
        addObject:[self sortParams:self.reviewSorts withKey:@"Sort_Reviews"]];
  }

  if (0 < self.questionSorts.count) {
    [params addObject:[self sortParams:self.questionSorts
                               withKey:@"Sort_Questions"]];
  }

  if (0 < self.answerSorts.count) {
    [params
        addObject:[self sortParams:self.answerSorts withKey:@"Sort_Answers"]];
  }

  return params;
}

@end
