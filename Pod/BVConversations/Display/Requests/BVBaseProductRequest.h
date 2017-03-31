//
//  BVBaseProductRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDPInclude.h"
#import "BVFilterOperator.h"
#import "BVReviewFilterType.h"
#import "BVQuestionFilterType.h"
#import "BVConversationsRequest.h"
#import "BVFilter.h"
#import "BVSortOptionReviews.h"
#import "BVSortOptionQuestions.h"
#import "BVSortOptionAnswers.h"
#import "BVSort.h"
#import "BVBulkProductResponse.h"

typedef void (^ProductSearchRequestCompletionHandler)(BVBulkProductResponse* _Nonnull response);

@interface BVBaseProductRequest : BVConversationsRequest

/// Type of social content to inlcude with the product request.
- (nonnull instancetype)includeContent:(PDPContentType)contentType limit:(int)limit;

// Includes statistics for the included content type.
- (nonnull instancetype)includeStatistics:(PDPContentType)contentType;

/// Inclusive filter to add for included reviews.
- (nonnull instancetype)addIncludedReviewsFilter:(BVReviewFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value;

/// Inclusive filter to add for included questions.
- (nonnull instancetype)addIncludedQuestionsFilter:(BVQuestionFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value;

/// Asynchronous call to fetch data for this request.

- (NSString* _Nonnull)statisticsToParams:(NSArray<NSNumber*>* _Nonnull)statistics;
- (NSString* _Nonnull)includesToParams:(NSArray<PDPInclude*>* _Nonnull)includes;

@end

@interface BVBaseProductsRequest : BVBaseProductRequest

- (void)load:(ProductSearchRequestCompletionHandler _Nonnull)success failure:(ConversationsFailureHandler _Nonnull)failure;

@end

@interface BVBaseSortableProductRequest : BVBaseProductsRequest


/// When adding reviews to include, you can add a sort parameter on the included reviews.
- (nonnull instancetype)sortIncludedReviews:(BVSortOptionReviews)option order:(BVSortOrder)order;
/// When adding questions to include, you can add a sort parameter on the included questions.
- (nonnull instancetype)sortIncludedQuestions:(BVSortOptionQuestions)option order:(BVSortOrder)order;
/// When adding answers to include, you can add a sort parameter on the included answer.
- (nonnull instancetype)sortIncludedAnswers:(BVSortOptionAnswers)option order:(BVSortOrder)order;

@end
