

//
//  BVBaseProductRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBaseProductRequest.h"

@interface BVBaseProductRequest ()

@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<BVFilter *> *reviewFilters;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<BVFilter *> *questionFilters;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<NSNumber *> *PDPContentTypeStatistics;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<PDPInclude *> *includes;

@end

@implementation BVBaseProductRequest

- (instancetype)init {
  if (self = [super init]) {
    _includes = [NSMutableArray array];
    _reviewFilters = [NSMutableArray array];
    _questionFilters = [NSMutableArray array];
    _PDPContentTypeStatistics = [NSMutableArray array];
  }

  return self;
}

- (nonnull NSString *)includesToParams:
    (nonnull NSArray<PDPInclude *> *)includes {
  NSMutableArray *strings = [NSMutableArray array];

  for (PDPInclude *include in includes) {
    [strings addObject:[include toParamString]];
  }

  NSArray<NSString *> *sortedArray = [strings
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

  return [sortedArray componentsJoinedByString:@","];
}

- (nonnull NSString *)statisticsToParams:
    (nonnull NSArray<NSNumber *> *)statistics {
  NSMutableArray *strings = [NSMutableArray array];

  for (NSNumber *stat in statistics) {
    [strings addObject:[PDPContentTypeUtil toString:[stat intValue]]];
  }

  NSArray<NSString *> *sortedArray = [strings
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

  return [sortedArray componentsJoinedByString:@","];
}

- (nonnull NSString *)endpoint {
  return @"products.json";
}

- (nonnull instancetype)includeContent:(PDPContentType)contentType
                                 limit:(int)limit {
  PDPInclude *include =
      [[PDPInclude alloc] initWithContentType:contentType limit:@(limit)];
  [self.includes addObject:include];
  return self;
}

- (nonnull instancetype)includeStatistics:(PDPContentType)contentType {
  [self.PDPContentTypeStatistics addObject:@(contentType)];
  return self;
}

- (nonnull instancetype)addIncludedReviewsFilter:(BVReviewFilterType)type
                                  filterOperator:
                                      (BVFilterOperator)filterOperator
                                           value:(nonnull NSString *)value {
  BVFilter *filter =
      [[BVFilter alloc] initWithString:[BVReviewFilterTypeUtil toString:type]
                        filterOperator:filterOperator
                                values:@[ value ]];

  [self.reviewFilters addObject:filter];
  return self;
}

- (nonnull instancetype)addIncludedQuestionsFilter:(BVQuestionFilterType)type
                                    filterOperator:
                                        (BVFilterOperator)filterOperator
                                             value:(nonnull NSString *)value {
  BVFilter *filter =
      [[BVFilter alloc] initWithString:[BVQuestionFilterTypeUtil toString:type]
                        filterOperator:filterOperator
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

  if (self.includes.count > 0) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Include"
                                value:[self includesToParams:self.includes]]];
  }

  NSString *pcts = [self statisticsToParams:self.PDPContentTypeStatistics];
  if (pcts && pcts.length > 0) {
    [params
        addObject:[BVStringKeyValuePair
                      pairWithKey:@"Stats"
                            value:[self statisticsToParams:
                                            self.PDPContentTypeStatistics]]];
  }

  for (PDPInclude *include in self.includes) {
    if (include.limit != nil) {
      NSString *key = [NSString
          stringWithFormat:@"Limit_%@",
                           [PDPContentTypeUtil toString:include.type]];
      BVStringKeyValuePair *pair = [BVStringKeyValuePair
          pairWithKey:key
                value:[NSString stringWithFormat:@"%@", include.limit]];
      [params addObject:pair];
    }
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
  if (self = [super init]) {
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
    [strings addObject:[sort toString]];
  }

  NSString *combined = [strings componentsJoinedByString:@","];

  return [BVStringKeyValuePair pairWithKey:paramKey value:combined];
}

- (nonnull instancetype)sortIncludedReviews:(BVSortOptionReviews)option
                                      order:(BVSortOrder)order {
  BVSort *sort = [[BVSort alloc]
      initWithOptionString:[BVSortOptionReviewUtil toString:option]
                     order:order];
  [self.reviewSorts addObject:sort];
  return self;
}

- (nonnull instancetype)sortIncludedQuestions:(BVSortOptionQuestions)option
                                        order:(BVSortOrder)order {
  BVSort *sort = [[BVSort alloc]
      initWithOptionString:[BVSortOptionQuestionsUtil toString:option]
                     order:order];
  [self.questionSorts addObject:sort];
  return self;
}

- (nonnull instancetype)sortIncludedAnswers:(BVSortOptionAnswers)option
                                      order:(BVSortOrder)order {
  BVSort *sort = [[BVSort alloc]
      initWithOptionString:[BVSortOptionAnswersUtil toString:option]
                     order:order];
  [self.answerSorts addObject:sort];
  return self;
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];

  if (self.reviewSorts.count > 0) {
    [params
        addObject:[self sortParams:self.reviewSorts withKey:@"Sort_Reviews"]];
  }

  if (self.questionSorts.count > 0) {
    [params addObject:[self sortParams:self.questionSorts
                               withKey:@"Sort_Questions"]];
  }

  if (self.answerSorts.count > 0) {
    [params
        addObject:[self sortParams:self.answerSorts withKey:@"Sort_Answers"]];
  }

  return params;
}

@end
