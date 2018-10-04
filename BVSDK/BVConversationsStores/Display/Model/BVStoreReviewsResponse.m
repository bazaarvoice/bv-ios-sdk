//
//  BVStoreReviewsResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVStoreReviewsResponse.h"
#import "BVConversationsInclude.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVNullHelper.h"
#import "BVReview.h"
#import "BVStore.h"

@implementation BVStoreReviewsResponse

- (id)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    NSDictionary *rawIncludes = (NSDictionary *)apiResponse[@"Includes"];
    self.store = [self extractStoreFromIncludes:rawIncludes];
  }
  return self;
}

- (BVStore *)extractStoreFromIncludes:(NSDictionary *)includesDict {
  NSDictionary *productsDict = includesDict[@"Products"];
  for (NSString *key in productsDict) {
    // We limit the initial request to only one store, so we just pick out
    // the first store.
    NSDictionary *storeDict = [productsDict objectForKey:key];

    return [[BVStore alloc] initWithApiResponse:storeDict];
  }

  // If there are no reviews in the response, the Products dictionary holding
  // the stores will be empty.
  return nil;
}

- (id)createResult:(NSDictionary *)raw
          includes:(BVConversationsInclude *)includes {
  return [[BVReview alloc] initWithApiResponse:raw includes:includes];
}

@end
