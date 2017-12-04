//
//  BVBaseProductRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBulkProductResponse.h"
#import "BVConversationsRequest.h"
#import "BVFilter.h"
#import "BVFilterOperator.h"
#import "BVQuestionFilterType.h"
#import "BVReviewFilterType.h"
#import "BVSort.h"
#import "BVSortOptionAnswers.h"
#import "BVSortOptionQuestions.h"
#import "BVSortOptionReviews.h"
#import "PDPInclude.h"
#import <Foundation/Foundation.h>

typedef void (^ProductSearchRequestCompletionHandler)(
    BVBulkProductResponse *__nonnull response);

@interface BVBaseProductRequest : BVConversationsRequest

/// Type of social content to inlcude with the product request. NOTE:
/// PDPContentType is only supported for statistics, no for Includes.
- (nonnull instancetype)includeContent:(PDPContentType)contentType
                                 limit:(int)limit;

// Includes statistics for the included content type.
- (nonnull instancetype)includeStatistics:(PDPContentType)contentType;

/// Inclusive filter to add for included reviews.
- (nonnull instancetype)addIncludedReviewsFilter:(BVReviewFilterType)type
                                  filterOperator:
                                      (BVFilterOperator)filterOperator
                                           value:(nonnull NSString *)value;

/// Inclusive filter to add for included questions.
- (nonnull instancetype)addIncludedQuestionsFilter:(BVQuestionFilterType)type
                                    filterOperator:
                                        (BVFilterOperator)filterOperator
                                             value:(nonnull NSString *)value;

/// Asynchronous call to fetch data for this request.

- (nonnull NSString *)statisticsToParams:
    (nonnull NSArray<NSNumber *> *)statistics;
- (nonnull NSString *)includesToParams:
    (nonnull NSArray<PDPInclude *> *)includes;

@end

@interface BVBaseProductsRequest : BVBaseProductRequest

- (void)load:(nonnull ProductSearchRequestCompletionHandler)success
     failure:(nonnull ConversationsFailureHandler)failure;

@end

@interface BVBaseSortableProductRequest : BVBaseProductsRequest

/// When adding reviews to include, you can add a sort parameter on the included
/// reviews.
- (nonnull instancetype)sortIncludedReviews:(BVSortOptionReviews)option
                                      order:(BVSortOrder)order;
/// When adding questions to include, you can add a sort parameter on the
/// included questions.
- (nonnull instancetype)sortIncludedQuestions:(BVSortOptionQuestions)option
                                        order:(BVSortOrder)order;
/// When adding answers to include, you can add a sort parameter on the included
/// answer.
- (nonnull instancetype)sortIncludedAnswers:(BVSortOptionAnswers)option
                                      order:(BVSortOrder)order
    __deprecated_msg("Including answers is not supported on product calls.");

@end
