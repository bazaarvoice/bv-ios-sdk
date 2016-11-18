//
//  BVStoreNotificationConfigurationLoader.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVStoreReviewNotificationProperties.h"

@interface BVStoreNotificationConfigurationLoader : NSObject

/**
    Configuration properties that determine display text and delay vaues for a store review notification.
 */
@property (strong, readonly) BVStoreReviewNotificationProperties * _Nonnull bvStoreReviewNotificationProperties;

+(id _Nonnull)sharedManager;

@end
