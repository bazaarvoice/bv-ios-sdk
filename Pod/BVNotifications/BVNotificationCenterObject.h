//
//  BVNotificationCenterObject.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#define ATTACHMENT_FILE_DIRECTORY                                              \
  [NSTemporaryDirectory() stringByAppendingString:@"BVSDK"]
#define ATTACHMENT_FILE_PATH                                                   \
  [ATTACHMENT_FILE_DIRECTORY stringByAppendingString:@"/temp.png"]
#define ATTACHMENT_THUMB_ID @"attachmentThumb"
#define ATTACHMENT_LL_ID @"attachmentLatLong"
#define STORE_NOTIFICATION_CUSTOM_CATEGORY                                     \
  [BVSDKManager sharedManager].configuration.storeReviewContentExtensionCategory
#define PIN_CUSTOM_CATEGORY                                                    \
  [BVSDKManager sharedManager].configuration.PINContentExtensionCategory

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#import "BVStore.h"
#import "BVStoreReviewNotificationProperties.h"

@protocol BVNotificationCenterObject <NSObject>

@optional
- (void)addNotificationCategories:
    (nonnull BVNotificationProperties *)notificationProperties;

- (void)userNotificationCenter:(nonnull UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response
    NS_AVAILABLE_IOS(10_0);

- (void)handleActionWithIdentifier:(nullable NSString *)identifier
              forLocalNotification:(nonnull UILocalNotification *)notification;

@end

@protocol BVProductNotificationCenterObject <BVNotificationCenterObject>

@optional
- (void)queueReviewWithProduct:(nonnull BVProduct *)product;
- (void)queueReviewWithProductId:(nonnull NSString *)productId;

@end

@protocol BVStoreNotificationCenterObject <BVNotificationCenterObject>

@optional
- (void)queueReviewWithStoreId:(nonnull NSString *)storeId;
- (void)queueReviewWithStore:(nonnull BVStore *)store;

@end
