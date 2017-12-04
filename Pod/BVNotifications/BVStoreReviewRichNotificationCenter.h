//
//  BVReviewNotificationCenter.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVNotificationCenterObject.h"
#import <Foundation/Foundation.h>

@interface BVStoreReviewRichNotificationCenter
    : NSObject <UNUserNotificationCenterDelegate,
                BVStoreNotificationCenterObject>

@end
