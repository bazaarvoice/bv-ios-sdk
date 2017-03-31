//
//  BVBaseReviewsRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVConversationsRequest.h"
#import "BVSort.h"
#import "BVSortOptionReviews.h"
#import "BVReviewFilterType.h"
#import "BVFilterOperator.h"
#import "BVResponse.h"
#import "BVReviewIncludeType.h"

@class BVFilter;

@interface BVBaseReviewsRequest<__covariant BVResponseType: id<BVResponse>> : BVConversationsRequest

- (nonnull instancetype) __unavailable init;
- (nonnull instancetype)initWithID:(NSString * _Nonnull)ID limit:(int)limit offset:(int)offset;

@property (nonatomic, assign, readonly) int limit;
@property (nonatomic, assign, readonly) int offset;
@property (nonatomic, strong, readonly) NSString* _Nullable ID;
@property (nonatomic, strong, readonly) NSString* _Nullable search;
@property (nonatomic, strong, readonly) NSMutableArray<BVSort*>* _Nonnull sorts;
@property (nonatomic, strong, readonly) NSMutableArray<BVFilter*>* _Nonnull filters;
@property (nonatomic, strong, readonly) NSMutableArray<NSString *> * _Nonnull includes;

- (void)sendReviewResultsAnalytics:(NSArray<BVReview *> * _Nonnull)reviews;
- (void)sendReviewsAnalytics:(BVReviewsResponse* _Nonnull)reviewsResponse;
- (nonnull instancetype)search:(NSString * _Nonnull)search;


- (nonnull instancetype)addInclude:(BVReviewIncludeType)include;

- (nonnull instancetype)addSort:(BVSortOptionProducts)option order:(BVSortOrder)order __deprecated_msg("use sortReviews instead");

- (nonnull instancetype)addReviewSort:(BVSortOptionReviews)option order:(BVSortOrder)order;

- (nonnull instancetype)addFilter:(BVReviewFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value;
- (nonnull instancetype)addFilter:(BVReviewFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString *> * _Nonnull)values;

- (void)load:(void (^ _Nonnull)(BVResponseType _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure;

- (nonnull BVResponseType)createResponse:(NSDictionary * _Nonnull)raw;

@end
