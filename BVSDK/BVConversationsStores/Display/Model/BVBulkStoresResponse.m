//
//  BVBulkStoresResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBulkStoresResponse.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVNullHelper.h"
#import "BVStore.h"

@implementation BVBulkStoresResponse

- (id)createResult:(NSDictionary *)raw
          includes:(BVConversationsInclude *)includes {
  return [[BVStore alloc] initWithApiResponse:raw includes:includes];
}

@end
