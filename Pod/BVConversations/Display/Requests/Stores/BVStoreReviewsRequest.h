//
//  BVStoreReviewsRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVBaseReviewsRequest.h"
#import "BVReviewFilterType.h"
#import "BVFilterOperator.h"
#import "BVSort.h"
#import "BVStoreReviewsResponse.h"
#import "BVReviewsRequest.h"
#import "BVStoreIncludeContentType.h"
#import "BVSortOptionReviews.h"

typedef void (^StoreReviewRequestCompletionHandler)(BVStoreReviewsResponse* _Nonnull response);

/*
 You can get multiple reviews and with this request object.
 Optionally, you can filter, sort, or search reviews using the `addSort*` and `addFilter*` and `search` methods.
 */
@interface BVStoreReviewsRequest : BVBaseReviewsRequest<BVStoreReviewsResponse *>

@property (readonly) NSString* _Nonnull storeId;

- (nonnull instancetype)initWithStoreId:(NSString * _Nonnull)storeId limit:(int)limit offset:(int)offset;

- (nonnull instancetype) __unavailable init;

- (nonnull instancetype)includeStatistics:(BVStoreIncludeContentType)contentType;

@end
