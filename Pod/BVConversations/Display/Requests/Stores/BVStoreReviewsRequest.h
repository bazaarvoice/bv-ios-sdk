//
//  BVStoreReviewsRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVConversationsRequest.h"
#import "BVReviewFilterType.h"
#import "BVFilterOperator.h"
#import "BVSort.h"
#import "BVStoreReviewsResponse.h"
#import "BVReviewsRequest.h"
#import "BVStoreIncludeContentType.h"
#import "BVSortOptionReviews.h"

/*
 You can get multiple reviews and with this request object.
 Optionally, you can filter, sort, or search reviews using the `addSort*` and `addFilter*` and `search` methods.
 */
@interface BVStoreReviewsRequest : BVConversationsRequest

@property (readonly) NSString* _Nonnull storeId;

- (nonnull instancetype)initWithStoreId:(NSString * _Nonnull)storeId limit:(int)limit offset:(int)offset;

- (nonnull instancetype) __unavailable init;

- (nonnull instancetype)includeStatistics:(BVStoreIncludeContentType)contentType;

- (nonnull instancetype)addSort:(BVSortOptionProducts)option order:(BVSortOrder)order; __deprecated_msg("use sortReviews instead");

- (nonnull instancetype)addReviewSort:(BVSortOptionReviews)option order:(BVSortOrder)order;

- (nonnull instancetype)addFilter:(BVReviewFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value;
- (nonnull instancetype)addFilter:(BVReviewFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString *> * _Nonnull)values;
- (nonnull instancetype)search:(NSString * _Nonnull)search;

- (void)load:(void (^ _Nonnull)(BVStoreReviewsResponse * _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure;
- (NSString * _Nonnull)endpoint;
- (NSMutableArray * _Nonnull)createParams;

@end
