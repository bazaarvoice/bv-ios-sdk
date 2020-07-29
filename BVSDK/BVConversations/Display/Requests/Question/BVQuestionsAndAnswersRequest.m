//
//  QuestionsAndAnswersRequest.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionsAndAnswersRequest.h"
#import "BVCommaUtil.h"
#import "BVCommon.h"
#import "BVConversationsRequest+Private.h"
#import "BVMonotonicSortOrder.h"
#import "BVQuestionFilterType.h"
#import "BVQuestionsSortOption.h"
#import "BVRelationalFilterOperator.h"
#import "BVStringKeyValuePair.h"

@interface BVQuestionsAndAnswersRequest ()

@property NSUInteger limit;
@property NSUInteger offset;
@property(nullable) NSString *search;
@property(nonnull) NSMutableArray<BVFilter *> *filters;
@property(nonnull) NSMutableArray<BVSort *> *sorts;

@end

@implementation BVQuestionsAndAnswersRequest

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                                    limit:(NSUInteger)limit
                                   offset:(NSUInteger)offset {
  if ((self = [super init])) {
    _productId = [BVCommaUtil escape:productId];
    self.limit = limit;
    self.offset = offset;

    self.filters = [NSMutableArray array];
    self.sorts = [NSMutableArray array];

    // filter the request to the given productId
    BVFilter *filter = [[BVFilter alloc]
        initWithFilterType:
            [BVQuestionFilterType
                filterTypeWithRawValue:BVQuestionFilterValueQuestionProductId]
            filterOperator:[BVRelationalFilterOperator
                               filterOperatorWithRawValue:
                                   BVRelationalFilterOperatorValueEqualTo]
                    values:@[ self.productId ]];
    [self.filters addObject:filter];
  }
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
  [self.sorts addObject:sort];
  return self;
}

- (nonnull instancetype)
  filterOnQuestionFilterValue:(BVQuestionFilterValue)questionFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value {
  [self filterOnQuestionFilterValue:questionFilterValue
      relationalFilterOperatorValue:relationalFilterOperatorValue
                             values:@[ value ]];
  return self;
}

- (nonnull instancetype)
  filterOnQuestionFilterValue:(BVQuestionFilterValue)questionFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                       values:(nonnull NSArray<NSString *> *)values {

  BVQuestionFilterType *questionFilterType =
      [BVQuestionFilterType filterTypeWithRawValue:questionFilterValue];

  BVRelationalFilterOperator *relationalFilterOperator =
      [BVRelationalFilterOperator
          filterOperatorWithRawValue:relationalFilterOperatorValue];

  [self addQuestionFilterType:questionFilterType
      relationalFilterOperator:relationalFilterOperator
                        values:values];

  return self;
}

- (nonnull instancetype)
   addQuestionFilterType:(nonnull BVQuestionFilterType *)questionFilterType
relationalFilterOperator:
    (nonnull BVRelationalFilterOperator *)relationalFilterOperator
                  values:(nonnull NSArray<NSString *> *)values {
  BVFilter *filter =
      [[BVFilter alloc] initWithFilterType:questionFilterType
                            filterOperator:relationalFilterOperator
                                    values:values];
  [self.filters addObject:filter];
  return self;
}

- (nonnull instancetype)search:(nonnull NSString *)search {
  self.search = search;
  return self;
}

- (void)load:(nonnull void (^)(
                 BVQuestionsAndAnswersResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure {
  // validate request
  if (1 > self.limit || 100 < self.limit) {
    [self sendError:[super limitError:self.limit] failureCallback:failure];
  } else {
    [self loadQuestions:self completion:success failure:failure];
  }
}

- (void)
loadQuestions:(nonnull BVConversationsRequest *)request
   completion:(nonnull void (^)(
                  BVQuestionsAndAnswersResponse *__nonnull response))completion
      failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
           BVQuestionsAndAnswersResponse *questionsAndAnswersResponse =
               [[BVQuestionsAndAnswersResponse alloc]
                   initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(questionsAndAnswersResponse);
           });
           [self sendQuestionsAnalytics:questionsAndAnswersResponse];
         }
            failure:failure];
}

- (void)sendQuestionsAnalytics:
    (BVQuestionsAndAnswersResponse *)questionsResponse {
  for (BVQuestion *question in questionsResponse.results) {
    // Record Question Impression
    BVImpressionEvent *questionImpression = [[BVImpressionEvent alloc]
           initWithProductId:question.productId
               withContentId:question.identifier
              withCategoryId:question.categoryId
             withProductType:BVPixelProductTypeConversationsQuestionAnswer
             withContentType:BVPixelImpressionContentTypeQuestion
                   withBrand:nil
        withAdditionalParams:nil];

    [BVPixel trackEvent:questionImpression];
  }

  // send pageview for product
  BVQuestion *question = questionsResponse.results.firstObject;
  if (question) {
    NSNumber *count = @([questionsResponse.results count]);
    NSDictionary *addParams = @{@"numQuestions" : count};

    BVPageViewEvent *pageView = [[BVPageViewEvent alloc]
             initWithProductId:question.productId
        withBVPixelProductType:BVPixelProductTypeConversationsQuestionAnswer
                     withBrand:nil
                withCategoryId:question.categoryId
            withRootCategoryId:nil
          withAdditionalParams:addParams];

    [BVPixel trackEvent:pageView];
  }
}

- (nonnull NSString *)endpoint {
  return @"questions.json";
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"Include" value:@"Answers"]];
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

  if ([self.sorts count] > 0) {
    NSMutableArray<NSString *> *sortsAsStrings = [NSMutableArray array];
    for (BVSort *sort in self.sorts) {
      [sortsAsStrings addObject:[sort toParameterString]];
    }
    NSString *allTogetherNow = [sortsAsStrings componentsJoinedByString:@","];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Sort"
                                                  value:allTogetherNow]];
  }

  return params;
}

@end
