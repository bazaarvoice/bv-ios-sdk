//
//  BVBaseReviewsRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVConversationsRequest.h"
#import "BVFilterOperator.h"
#import "BVResponse.h"
#import "BVReviewFilterType.h"
#import "BVReviewIncludeType.h"
#import "BVSort.h"
#import "BVSortOptionReviews.h"
#import <Foundation/Foundation.h>

@class BVFilter;

@interface BVBaseReviewsRequest < __covariant BVResponseType : id <BVResponse>
> : BVConversationsRequest

    - (nonnull instancetype)__unavailable init;
- (nonnull instancetype)initWithID:(nonnull NSString *)ID
                             limit:(int)limit
                            offset:(int)offset;

@property(nonatomic, assign, readonly) int limit;
@property(nonatomic, assign, readonly) int offset;
@property(nullable, nonatomic, strong, readonly) NSString *ID;
@property(nullable, nonatomic, strong, readonly) NSString *search;
@property(nonnull, nonatomic, strong, readonly) NSMutableArray<BVSort *> *sorts;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<BVFilter *> *filters;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<NSString *> *includes;

- (void)sendReviewResultsAnalytics:(nonnull NSArray<BVReview *> *)reviews;
- (void)sendReviewsAnalytics:(nonnull BVReviewsResponse *)reviewsResponse;
- (nonnull instancetype)search:(nonnull NSString *)search;

- (nonnull instancetype)addInclude:(BVReviewIncludeType)include;

- (nonnull instancetype)addSort:(BVSortOptionProducts)option
                          order:(BVSortOrder)order
    __deprecated_msg("use sortReviews instead");

- (nonnull instancetype)addReviewSort:(BVSortOptionReviews)option
                                order:(BVSortOrder)order;

- (nonnull instancetype)addFilter:(BVReviewFilterType)type
                   filterOperator:(BVFilterOperator)filterOperator
                            value:(nonnull NSString *)value;
- (nonnull instancetype)addFilter:(BVReviewFilterType)type
                   filterOperator:(BVFilterOperator)filterOperator
                           values:(nonnull NSArray<NSString *> *)values;

- (void)load:(nonnull void (^)(BVResponseType __nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;

- (nonnull BVResponseType)createResponse:(nonnull NSDictionary *)raw;

@end
