//
//  QuestionsAndAnswersRequest.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationDisplay.h"
#import "BVConversationsRequest.h"
#import "BVQuestionsAndAnswersResponse.h"

typedef void (^QuestionsAndAnswersSuccessHandler)(
    BVQuestionsAndAnswersResponse *__nonnull response);

/*
 You can get multiple questions and their associated answers with this request
 object.
 Optionally, you can filter, sort, or search reviews using the `addSort*` and
 `addFilter*` and `search` methods.
 */
@interface BVQuestionsAndAnswersRequest : BVConversationsRequest

@property(nonnull, readonly) NSString *productId;

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                                    limit:(NSUInteger)limit
                                   offset:(NSUInteger)offset;
- (nonnull instancetype)__unavailable init;

- (nonnull instancetype)sortByQuestionsSortOptionValue:
                            (BVQuestionsSortOptionValue)questionsSortOptionValue
                               monotonicSortOrderValue:
                                   (BVMonotonicSortOrderValue)
                                       monotonicSortOrderValue;

- (nonnull instancetype)
  filterOnQuestionFilterValue:(BVQuestionFilterValue)questionFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value;

- (nonnull instancetype)
  filterOnQuestionFilterValue:(BVQuestionFilterValue)questionFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                       values:(nonnull NSArray<NSString *> *)values;

- (nonnull instancetype)search:(nonnull NSString *)search;

- (void)load:(nonnull void (^)(
                 BVQuestionsAndAnswersResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;
- (nonnull NSString *)endpoint;
- (nonnull NSMutableArray *)createParams;

@end
