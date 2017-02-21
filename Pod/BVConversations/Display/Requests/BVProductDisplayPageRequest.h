//
//  ProductDisplayPageRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVConversationsRequest.h"
#import "PDPContentType.h"
#import "BVSortOptionReviews.h"
#import "BVSortOptionQuestions.h"
#import "BVSortOptionAnswers.h"
#import "BVSort.h"
#import "PDPInclude.h"
#import "BVFilterOperator.h"
#import "BVReviewFilterType.h"
#import "BVQuestionFilterType.h"


/*
 You can retrieve all information needed for a Product Display Page with this request.
 Optionally, you can include `Reviews` or `QuestionsAndAnswers` as well as statistics on 
 reviews and questions and answers.
 Optionally, you can filter and sort the questions using the `addSort*` and `addFilter*` methods.
 */
@interface BVProductDisplayPageRequest : BVConversationsRequest


/// Initialize the request for the product ID you are displaying on your product page.
- (nonnull instancetype)initWithProductId:(NSString * _Nonnull)productId;
- (nonnull instancetype) __unavailable init;

/// Type of social content to inlcude with the product request.
- (nonnull instancetype)includeContent:(PDPContentType)contentType limit:(int)limit;

// Includes statistics for the included content type.
- (nonnull instancetype)includeStatistics:(PDPContentType)contentType;

/// When adding reviews to include, you can add a sort parameter on the included reviews.
- (nonnull instancetype)sortIncludedReviews:(BVSortOptionReviews)option order:(BVSortOrder)order;
/// When adding questions to include, you can add a sort parameter on the included questions.
- (nonnull instancetype)sortIncludedQuestions:(BVSortOptionQuestions)option order:(BVSortOrder)order;
/// When adding answers to include, you can add a sort parameter on the included answer.
- (nonnull instancetype)sortIncludedAnswers:(BVSortOptionAnswers)option order:(BVSortOrder)order;

/// Inclusive filter to add for included reviews.
- (nonnull instancetype)addIncludedReviewsFilter:(BVReviewFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value;

/// Inclusive filter to add for included questions.
- (nonnull instancetype)addIncludedQuestionsFilter:(BVQuestionFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value;

/// Asynchronous call to fetch data for this request.
- (void)load:(ProductRequestCompletionHandler _Nonnull)success failure:(ConversationsFailureHandler _Nonnull)failure;

- (NSString * _Nonnull)endpoint;
- (NSMutableArray * _Nonnull)createParams;
- (NSString* _Nonnull)statisticsToParams:(NSArray<NSNumber*>* _Nonnull)statistics;
- (NSString* _Nonnull)includesToParams:(NSArray<PDPInclude*>* _Nonnull)includes;


@end
