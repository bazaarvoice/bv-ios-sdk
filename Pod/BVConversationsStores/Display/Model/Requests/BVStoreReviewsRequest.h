//
//  BVStoreReviewsRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBaseReviewsRequest.h"
#import "BVFilterOperator.h"
#import "BVReviewFilterType.h"
#import "BVReviewsRequest.h"
#import "BVSort.h"
#import "BVSortOptionReviews.h"
#import "BVStoreIncludeContentType.h"
#import "BVStoreReviewsResponse.h"
#import <Foundation/Foundation.h>

typedef void (^StoreReviewRequestCompletionHandler)(
    BVStoreReviewsResponse *__nonnull response);

/*
 You can get multiple reviews and with this request object.
 Optionally, you can filter, sort, or search reviews using the `addSort*` and
 `addFilter*` and `search` methods.
 */
@interface BVStoreReviewsRequest
    : BVBaseReviewsRequest <BVStoreReviewsResponse *>

@property(nonnull, readonly) NSString *storeId;

- (nonnull instancetype)initWithStoreId:(nonnull NSString *)storeId
                                  limit:(int)limit
                                 offset:(int)offset;

- (nonnull instancetype)__unavailable init;

- (nonnull instancetype)includeStatistics:
    (BVStoreIncludeContentType)contentType;

@end
