//
//  BVStoreNotificationConfigurationLoader+Private.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#ifndef BVProductReviewNotificationConfigurationLoader_Private_h
#define BVProductReviewNotificationConfigurationLoader_Private_h

@interface BVProductReviewNotificationConfigurationLoader (Testing)

- (void)loadPINConfiguration:
            (nonnull void (^)(BVProductReviewNotificationProperties *__nonnull
                                  response))completion
                     failure:
                         (nonnull void (^)(NSError *__nonnull error))failure;

@end

#endif /* BVProductReviewNotificationConfigurationLoader_Private_h */
