//
//  BVNotificationViewController.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

#import "BVNotificationConstants.h"

@protocol BVNotificationHandler;
@interface BVNotificationViewController
    : UIViewController <UNNotificationContentExtension>

@end
