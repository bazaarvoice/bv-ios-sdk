//
//  QuestionsAndAnswersRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationsRequest.h"
#import "BVFilterOperator.h"
#import "BVQuestionFilterType.h"
#import "BVQuestionsAndAnswersResponse.h"
#import "BVSort.h"
#import "BVSortOptionAnswers.h"
#import "BVSortOptionQuestions.h"
#import <Foundation/Foundation.h>

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
                                    limit:(int)limit
                                   offset:(int)offset;
- (nonnull instancetype)__unavailable init;

- (nonnull instancetype)addSort:(BVSortOptionProducts)option
                          order:(BVSortOrder)order
    __deprecated_msg("use sortQuestions and sortAnswers instead");

- (nonnull instancetype)addQuestionSort:(BVSortOptionQuestions)option
                                  order:(BVSortOrder)order;

- (nonnull instancetype)addFilter:(BVQuestionFilterType)type
                   filterOperator:(BVFilterOperator)filterOperator
                            value:(nonnull NSString *)value;
- (nonnull instancetype)addFilter:(BVQuestionFilterType)type
                   filterOperator:(BVFilterOperator)filterOperator
                           values:(nonnull NSArray<NSString *> *)values;
- (nonnull instancetype)search:(nonnull NSString *)search;

- (void)load:(nonnull void (^)(
                 BVQuestionsAndAnswersResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;
- (nonnull NSString *)endpoint;
- (nonnull NSMutableArray *)createParams;

@end
