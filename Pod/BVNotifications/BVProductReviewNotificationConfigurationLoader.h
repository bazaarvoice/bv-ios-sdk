//
//  BVProductReviewNotificationConfigurationLoader.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVProductReviewNotificationProperties.h"

@interface BVProductReviewNotificationConfigurationLoader : NSObject

/**
  Configuration properties that determine display text and delay vaues for a product review notification.
 */
@property (strong, readonly) BVProductReviewNotificationProperties * _Nonnull bvProductReviewNotificationProperties;

+(id _Nonnull)sharedManager;

@end
