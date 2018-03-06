//
//  BVBaseProductRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBulkProductResponse.h"
#import "BVConversationDisplay.h"
#import "BVConversationsRequest.h"

typedef void (^ProductSearchRequestCompletionHandler)(
    BVBulkProductResponse *__nonnull response);

@interface BVBaseProductRequest : BVConversationsRequest

/// Type of social content to include with the product request. NOTE:
/// BVProductIncludeTypeValue is only supported for statistics, no for Includes.
- (nonnull instancetype)includeProductIncludeTypeValue:
                            (BVProductIncludeTypeValue)productIncludeTypeValue
                                                 limit:(NSUInteger)limit;

// Includes statistics for the included content type.
- (nonnull instancetype)includeStatistics:
    (BVProductIncludeTypeValue)productIncludeTypeValue;

/// Inclusive filter to add for included reviews.
- (nonnull instancetype)
    filterOnReviewFilterValue:(BVReviewFilterValue)reviewFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value;

/// Inclusive filter to add for included questions.
- (nonnull instancetype)
  filterOnQuestionFilterValue:(BVQuestionFilterValue)questionFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value;

@end

@interface BVBaseProductsRequest : BVBaseProductRequest

/// Asynchronous call to fetch data for this request.
- (void)load:(nonnull ProductSearchRequestCompletionHandler)success
     failure:(nonnull ConversationsFailureHandler)failure;

@end

@interface BVBaseSortableProductRequest : BVBaseProductsRequest

/// When adding reviews to include, you can add a sort parameter on the included
/// reviews.
- (nonnull instancetype)
sortByReviewsSortOptionValue:(BVReviewsSortOptionValue)reviewsSortOptionValue
     monotonicSortOrderValue:(BVMonotonicSortOrderValue)monotonicSortOrderValue;
/// When adding questions to include, you can add a sort parameter on the
/// included questions.
- (nonnull instancetype)sortByQuestionsSortOptionValue:
                            (BVQuestionsSortOptionValue)questionsSortOptionValue
                               monotonicSortOrderValue:
                                   (BVMonotonicSortOrderValue)
                                       monotonicSortOrderValue;

@end
