//
//  BVStoreNotificationConfigurationLoader+Private.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#ifndef BVStoreNotificationConfigurationLoader_Private_h
#define BVStoreNotificationConfigurationLoader_Private_h

@interface BVStoreNotificationConfigurationLoader (Testing)

-(void)loadStoreNotificationConfiguration:(void (^ _Nonnull)(BVStoreReviewNotificationProperties * _Nonnull response))completion failure:(void (^ _Nonnull)(NSError * _Nonnull error))failure;

@end

#endif /* BVStoreNotificationConfigurationLoader_Private_h */
