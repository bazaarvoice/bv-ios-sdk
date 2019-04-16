//
//  BVBaseReviewsRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVConversationDisplay.h"
#import "BVConversationsRequest.h"
#import "BVReviewsResponse.h"

@interface BVBaseReviewsRequest < __covariant BVResponseType
    : BVDisplayResponse <BVReview *>
* > : BVConversationsRequest

      - (nonnull instancetype)__unavailable init;
- (nonnull instancetype)initWithID:(nonnull NSString *)ID
                             limit:(NSUInteger)limit
                            offset:(NSUInteger)offset
                        primaryFilter:(BVReviewFilterValue)primaryFilter;

@property(nonatomic, assign, readonly) NSUInteger limit;
@property(nonatomic, assign, readonly) NSUInteger offset;
@property(nullable, nonatomic, strong, readonly) NSString *ID;
@property(nullable, nonatomic, strong, readonly) NSString *search;

- (void)sendReviewResultsAnalytics:(nonnull NSArray<BVReview *> *)reviews;
- (void)sendReviewsAnalytics:(nonnull BVReviewsResponse *)reviewsResponse;
- (nonnull instancetype)search:(nonnull NSString *)search;

- (nonnull instancetype)includeReviewIncludeTypeValue:
    (BVReviewIncludeTypeValue)reviewIncludeTypeValue;

- (nonnull instancetype)
sortByReviewsSortOptionValue:(BVReviewsSortOptionValue)reviewsSortOptionValue
     monotonicSortOrderValue:(BVMonotonicSortOrderValue)monotonicSortOrderValue;

- (nonnull instancetype)
    filterOnReviewFilterValue:(BVReviewFilterValue)reviewFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value;
- (nonnull instancetype)
    filterOnReviewFilterValue:(BVReviewFilterValue)reviewFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                       values:(nonnull NSArray<NSString *> *)values;

- (void)load:(nonnull void (^)(BVResponseType __nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;

- (nonnull BVResponseType)createResponse:(nonnull NSDictionary *)raw;

@end
