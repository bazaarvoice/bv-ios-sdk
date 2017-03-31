//
//  BVBulkStoresResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVResponse.h"
#import "BVStore.h"
#import "BVBaseConversationsResponse.h"
/**
 A response to a `BVBulkStoresRequest`. Contains one or multiple (up to 20) `BVStore` objects in the `results` array.
 Contains other response information like the current index of pagination (`offset` property), and how many total results
 are available (`totalResults` property).
 */
@interface BVBulkStoresResponse : BVBaseConversationsResultsResponse<BVStore*><BVResponse>

@end
