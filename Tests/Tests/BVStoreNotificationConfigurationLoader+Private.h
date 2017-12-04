//
//  BVStoreNotificationConfigurationLoader+Private.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#ifndef BVStoreNotificationConfigurationLoader_Private_h
#define BVStoreNotificationConfigurationLoader_Private_h

@interface BVStoreNotificationConfigurationLoader (Testing)

- (void)
loadStoreNotificationConfiguration:
    (nonnull void (^)(BVStoreReviewNotificationProperties *__nonnull response))
        completion
                           failure:(nonnull void (^)(NSError *__nonnull error))
                                       failure;

@end

#endif /* BVStoreNotificationConfigurationLoader_Private_h */
