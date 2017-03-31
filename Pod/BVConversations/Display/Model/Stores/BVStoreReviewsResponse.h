//
//  BVStoreReviewsResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVResponse.h"
#import "BVReview.h"
#import "BVStore.h"
#import "BVBaseConversationsResponse.h"

/**
 A response to a `BVStoreReviewsRequest`. Contains one or multiple (up to 20) `BVReview` objects in the `results` array.
 Contains other response information like the current index of pagination (`offset` property), and how many total results
 are available (`totalResults` property).
 
 The `BVStore` is also available and non-nil as long as the results array is not empty. The `BVStore` property may also have `BVReviewStatistics` associated with it if the request indicitated to include review statistics.
 */
@interface BVStoreReviewsResponse : BVBaseConversationsResultsResponse<BVReview*>

@property BVStore* _Nullable store;

@end
