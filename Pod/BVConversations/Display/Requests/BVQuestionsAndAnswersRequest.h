//
//  QuestionsAndAnswersRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVConversationsRequest.h"
#import "BVQuestionFilterType.h"
#import "BVFilterOperator.h"
#import "BVSort.h"
#import "BVSortOptionQuestions.h"
#import "BVSortOptionAnswers.h"
#import "BVQuestionsAndAnswersResponse.h"

typedef void (^QuestionsAndAnswersSuccessHandler)(BVQuestionsAndAnswersResponse* _Nonnull response);

/*
 You can get multiple questions and their associated answers with this request object.
 Optionally, you can filter, sort, or search reviews using the `addSort*` and `addFilter*` and `search` methods.
 */
@interface BVQuestionsAndAnswersRequest : BVConversationsRequest

@property (readonly) NSString* _Nonnull productId;

- (nonnull instancetype)initWithProductId:(NSString * _Nonnull)productId limit:(int)limit offset:(int)offset;
- (nonnull instancetype) __unavailable init;

- (nonnull instancetype)addSort:(BVSortOptionProducts)option order:(BVSortOrder)order __deprecated_msg("use sortQuestions and sortAnswers instead");

- (nonnull instancetype)addQuestionSort:(BVSortOptionQuestions)option order:(BVSortOrder)order;

- (nonnull instancetype)addFilter:(BVQuestionFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value;
- (nonnull instancetype)addFilter:(BVQuestionFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString *> * _Nonnull)values;
- (nonnull instancetype)search:(NSString * _Nonnull)search;

- (void)load:(void (^ _Nonnull)(BVQuestionsAndAnswersResponse * _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure;
- (NSString * _Nonnull)endpoint;
- (NSMutableArray * _Nonnull)createParams;

@end
