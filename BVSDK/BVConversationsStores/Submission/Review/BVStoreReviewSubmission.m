//
//  BVStoreReviewSubmission.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVStoreReviewSubmission.h"
#import "BVBaseUGCSubmission+Private.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager+Private.h"
#import "BVUploadableStorePhoto.h"

@interface BVStoreReviewSubmission ()
@end

@implementation BVStoreReviewSubmission

- (NSString *)conversationsKey {
  NSString *key =
      [BVSDKManager sharedManager].configuration.apiKeyConversationsStores;
  NSAssert(key, @"Conversations Stores key isn't configured");
  return key;
}

- (nonnull instancetype)initWithReviewTitle:(nonnull NSString *)reviewTitle
                                 reviewText:(nonnull NSString *)reviewText
                                     rating:(NSUInteger)rating
                                    storeId:(nonnull NSString *)storeId {
  return [self initWithReviewTitle:reviewTitle
                        reviewText:reviewText
                            rating:rating
                         productId:storeId];
}

@end
