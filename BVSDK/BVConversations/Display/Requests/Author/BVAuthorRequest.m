//
//  BVAuthorRequest.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAuthorRequest.h"
#import "BVAnswersSortOption.h"
#import "BVAuthorIncludeType.h"
#import "BVCommaUtil.h"
#import "BVConversationsRequest+Private.h"
#import "BVLogger.h"
#import "BVMonotonicSortOrder.h"
#import "BVPixel.h"
#import "BVQuestionsSortOption.h"
#import "BVRelationalFilterOperator.h"
#import "BVReviewsSortOption.h"
#import "BVSort.h"

@interface BVAuthorRequest ()

@property NSUInteger limit;
@property NSUInteger offset;
@property(nullable) NSString *search;
@property(nonnull) NSMutableArray<BVFilter *> *filters;
@property(nonnull) NSMutableArray<BVAuthorIncludeType *> *authorIncludeTypes;
@property NSMutableArray<BVInclude *> *includes;
@property(nonnull) NSMutableArray<BVSort *> *reviewSorts;
@property(nonnull) NSMutableArray<BVSort *> *questionSorts;
@property(nonnull) NSMutableArray<BVSort *> *answerSorts;

@end

@implementation BVAuthorRequest

- (nonnull instancetype)initWithAuthorId:(nonnull NSString *)authorId {
  return [self initWithAuthorId:authorId limit:1 offset:0];
}

- (nonnull instancetype)initWithAuthorId:(nonnull NSString *)authorId
                                   limit:(NSUInteger)limit
                                  offset:(NSUInteger)offset {
  if ((self = [super init])) {
    self.authorIncludeTypes = [NSMutableArray array];
    self.filters = [NSMutableArray array];

    self.includes = [NSMutableArray array];
    self.reviewSorts = [NSMutableArray array];
    self.questionSorts = [NSMutableArray array];
    self.answerSorts = [NSMutableArray array];

    _authorId = [BVCommaUtil escape:authorId];

    self.limit = limit;
    self.offset = offset;

    self.filters = [NSMutableArray array];

    // filter the request to the given productId
    BVFilter *filter = [[BVFilter alloc]
        initWithString:@"Id"
        filterOperator:[BVRelationalFilterOperator
                           filterOperatorWithRawValue:
                               BVRelationalFilterOperatorValueEqualTo]
                values:@[ self.authorId ]];
    [self.filters addObject:filter];
  }
  return self;
}

- (nonnull instancetype)includeStatistics:
    (BVAuthorIncludeTypeValue)authorIncludeTypeValue {
  if (authorIncludeTypeValue == BVAuthorIncludeTypeValueAuthorReviewComments) {
    NSAssert(NO, @"Including Review Comment Statistics is not supported "
                 @"with an authors request.");
    return self;
  }

  [self.authorIncludeTypes
      addObject:[BVAuthorIncludeType
                    includeTypeWithRawValue:authorIncludeTypeValue]];
  return self;
}

- (nonnull instancetype)includeAuthorIncludeTypeValue:
                            (BVAuthorIncludeTypeValue)authorIncludeTypeValue
                                                limit:(NSUInteger)limit {

  BVInclude *include = [[BVInclude alloc]
      initWithIncludeType:[BVAuthorIncludeType
                              includeTypeWithRawValue:authorIncludeTypeValue]
             includeLimit:@(limit)];

  [self.includes addObject:include];
  return self;
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

- (nonnull instancetype)
sortByAnswersSortOptionValue:(BVAnswersSortOptionValue)answersSortOptionValue
     monotonicSortOrderValue:
         (BVMonotonicSortOrderValue)monotonicSortOrderValue {

  BVSort *sort = [[BVSort alloc]
      initWithSortOption:[BVAnswersSortOption
                             sortOptionWithRawValue:answersSortOptionValue]
               sortOrder:[BVMonotonicSortOrder
                             sortOrderWithRawValue:monotonicSortOrderValue]];
  [self.answerSorts addObject:sort];
  return self;
}

- (void)load:(nonnull void (^)(BVAuthorResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure {
  if (1 > self.limit || 100 < self.limit) {
    // invalid request
    [self sendError:[super limitError:self.limit] failureCallback:failure];
  } else {
    [self loadProfile:self completion:success failure:failure];
  }
}

- (void)
loadProfile:(nonnull BVConversationsRequest *)request
 completion:(nonnull void (^)(BVAuthorResponse *__nonnull response))completion
    failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
           BVAuthorResponse *authorResponse =
               [[BVAuthorResponse alloc] initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(authorResponse);
           });

           if (authorResponse && authorResponse.results) {
             [self sendAuthorAnalytics:authorResponse.results.firstObject];
           }

         }
            failure:failure];
}

- (void)sendAuthorAnalytics:(BVAuthor *)author {
  if (author) {
    // send usedfeature for the author display

    BVFeatureUsedEvent *event = [[BVFeatureUsedEvent alloc]
           initWithProductId:@"none"
                   withBrand:nil
             withProductType:BVPixelProductTypeConversationsProfile
               withEventName:BVPixelFeatureUsedNameProfile
        withAdditionalParams:@{
          @"interaction" : @"false",
          @"page" : author.authorId
        }];

    [BVPixel trackEvent:event];
  }
}

- (nonnull NSString *)endpoint {
  return @"authors.json";
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"Search" value:self.search]];
  [params
      addObject:[BVStringKeyValuePair
                    pairWithKey:@"Limit"
                          value:[NSString
                                    stringWithFormat:@"%i", (int)self.limit]]];
  [params
      addObject:[BVStringKeyValuePair
                    pairWithKey:@"Offset"
                          value:[NSString
                                    stringWithFormat:@"%i", (int)self.offset]]];

  for (BVFilter *filter in self.filters) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Filter"
                                value:[filter toParameterString]]];
  }

  NSString *stats = [self statisticsToParams:self.authorIncludeTypes];
  if (stats && stats.length > 0) {
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Stats" value:stats]];
  }

  if (0 < self.includes.count) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Include"
                                value:[self includesToParams:self.includes]]];
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

- (nonnull NSString *)includesToParams:
    (nonnull NSArray<BVInclude *> *)includes {
  NSMutableArray *strings = [NSMutableArray array];

  for (BVInclude *include in includes) {
    [strings addObject:[include toParameterString]];
  }

  NSArray<NSString *> *sortedArray = [strings
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

  return [sortedArray componentsJoinedByString:@","];
}

- (nonnull NSString *)statisticsToParams:
    (nonnull NSArray<BVAuthorIncludeType *> *)statistics {
  NSMutableArray<NSString *> *strings = [NSMutableArray array];

  for (BVAuthorIncludeType *stat in statistics) {
    [strings addObject:stat.toIncludeTypeParameterString];
  }

  NSArray<NSString *> *sortedArray = [strings
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

  return [sortedArray componentsJoinedByString:@","];
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

@end
