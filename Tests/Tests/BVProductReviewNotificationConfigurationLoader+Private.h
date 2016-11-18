//
//  BVStoreNotificationConfigurationLoader+Private.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#ifndef BVProductReviewNotificationConfigurationLoader_Private_h
#define BVProductReviewNotificationConfigurationLoader_Private_h

@interface BVProductReviewNotificationConfigurationLoader (Testing)

-(void)loadPINConfiguration:(void (^ _Nonnull)(BVProductReviewNotificationProperties * _Nonnull response))completion failure:(void (^ _Nonnull)(NSError * _Nonnull error))failure;

@end

#endif /* BVProductReviewNotificationConfigurationLoader_Private_h */
