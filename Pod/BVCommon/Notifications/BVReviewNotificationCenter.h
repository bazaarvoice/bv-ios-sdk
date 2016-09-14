//
//  BVReviewNotificationCenter.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVNotificationConstants.h"
#import "BVNotificationCenterObject.h"

@interface BVReviewNotificationCenter : NSObject<BVNotificationCenterObject>

+ (void)userNotificationCenter:(UNUserNotificationCenter* _Nonnull)center didReceiveNotificationResponse:(UNNotificationResponse * _Nonnull)response;

+ (void)handleActionWithIdentifier:(NSString * _Nullable)identifier forLocalNotification:(UILocalNotification * _Nonnull)notification;

-(id _Null_unspecified)init __attribute__((unavailable("Use sharedCenter")));

+(instancetype _Nonnull)sharedCenter;

@end
