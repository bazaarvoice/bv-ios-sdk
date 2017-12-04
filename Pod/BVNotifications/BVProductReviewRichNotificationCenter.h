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

@end
