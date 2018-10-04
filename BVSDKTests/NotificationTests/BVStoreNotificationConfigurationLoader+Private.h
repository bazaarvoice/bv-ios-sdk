//
//  BVStoreNotificationConfigurationLoader+Private.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#ifndef BVSTORENOTIFICATIONCONFIGURATIONLOADER_PRIVATE_H
#define BVSTORENOTIFICATIONCONFIGURATIONLOADER_PRIVATE_H

@interface BVStoreNotificationConfigurationLoader (Testing)

- (void)
loadStoreNotificationConfiguration:
    (nonnull void (^)(BVStoreReviewNotificationProperties *__nonnull response))
        completion
                           failure:(nonnull void (^)(NSError *__nonnull error))
                                       failure;

@end

#endif /* BVSTORENOTIFICATIONCONFIGURATIONLOADER_PRIVATE_H */
