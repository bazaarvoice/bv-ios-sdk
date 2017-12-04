//
//  BVStoreItemsRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import "BVBulkStoresResponse.h"
#import "BVConversationsRequest.h"
#import "BVSort.h"
#import "BVSortOptionReviews.h"
#import "BVStoreIncludeContentType.h"
#import <Foundation/Foundation.h>

/**
    Use the BVBulkStoreItemsRequest object for making requests to either fetch
   stores by limit and offset, or by specific store Id(s).
    Please use the designated initializers for each use case:

    • init:(int)limit offset:(int)offset - Use this initializer when you want to
   load multiple stores in batches.
    • (nonnull instancetype)initWithStoreIds:(NSArray * nonnull)storeIds - Use
   this initializer when you know the store Id or Ids you want to fetch.
 */
@interface BVBulkStoreItemsRequest : BVConversationsRequest

/// Initialize fetching of stores when requesting many store objects at once
/// and/or paging
- (nonnull instancetype)init:(int)limit offset:(int)offset;
/// Initialize to return a specific set of store Ids
- (nonnull instancetype)initWithStoreIds:(nonnull NSArray *)storeIds;

- (nonnull instancetype)__unavailable
    init; // Use the designated initializers only.

/// When you apply PDPContentTypeReviews to the content type, you will get
/// review statistics in the BVStore object(s)
- (nonnull instancetype)includeStatistics:
    (BVStoreIncludeContentType)contentType;

/// Make the asynchronous call from the request object.
- (void)load:(nonnull void (^)(BVBulkStoresResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;

- (nonnull NSString *)endpoint;
- (nonnull NSMutableArray *)createParams;

@end
