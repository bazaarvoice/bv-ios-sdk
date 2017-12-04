//
//  BVStoreReviewSubmission.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVStoreReviewSubmission.h"
#import "BVReviewSubmissionErrorResponse.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager.h"
#import "BVUploadableStorePhoto.h"

@interface BVStoreReviewSubmission ()

@end

@implementation BVStoreReviewSubmission

- (nonnull instancetype)initWithReviewTitle:(nonnull NSString *)reviewTitle
                                 reviewText:(nonnull NSString *)reviewText
                                     rating:(NSUInteger)rating
                                    storeId:(nonnull NSString *)storeId {
  self = [self initWithReviewTitle:reviewTitle
                        reviewText:reviewText
                            rating:rating
                         productId:storeId];
  return self;
}

- (void)addPhoto:(nonnull UIImage *)image
    withPhotoCaption:(nullable NSString *)photoCaption {
  BVUploadableStorePhoto *photo =
      [[BVUploadableStorePhoto alloc] initWithPhoto:image
                                       photoCaption:photoCaption];
  [self.photos addObject:photo];
}

- (nonnull NSString *)getPasskey {
  return [BVSDKManager sharedManager].configuration.apiKeyConversationsStores;
}

@end
