//
//  BVProuductReviewRichNotificationCenter.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVNotificationCenterObject.h"
#import <Foundation/Foundation.h>

@interface BVProductReviewRichNotificationCenter
    : NSObject <UNUserNotificationCenterDelegate,
                BVProductNotificationCenterObject>

- (void)userNotificationCenter:(nonnull UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response
    NS_AVAILABLE_IOS(10_0);

@end
