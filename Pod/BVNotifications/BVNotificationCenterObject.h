//
//  BVNotificationCenterObject.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


#define ATTACHMENT_FILE_DIRECTORY  [NSTemporaryDirectory() stringByAppendingString:@"BVSDK"]
#define ATTACHMENT_FILE_PATH      [ATTACHMENT_FILE_DIRECTORY stringByAppendingString:@"/temp.png"]
#define ATTACHMENT_THUMB_ID    @"attachmentThumb"
#define ATTACHMENT_LL_ID    @"attachmentLatLong"
#define STORE_NOTIFICATION_CUSTOM_CATEGORY    [[BVSDKManager sharedManager] storeReviewContentExtensionCategory]
#define PIN_CUSTOM_CATEGORY    [[BVSDKManager sharedManager] PINContentExtensionCategory]

#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

#import "BVStoreReviewNotificationProperties.h"
#import "BVStore.h"
#import "BVPIN.h"

@protocol BVNotificationCenterObject <NSObject>

@optional
- (void)addNotificationCategories:(BVNotificationProperties * _Nonnull)notificationProperties;

- (void)userNotificationCenter:(UNUserNotificationCenter* _Nonnull)center didReceiveNotificationResponse:(UNNotificationResponse * _Nonnull)response;

- (void)handleActionWithIdentifier:(NSString * _Nullable)identifier forLocalNotification:(UILocalNotification * _Nonnull)notification;

@end

@protocol BVProductNotificationCenterObject <BVNotificationCenterObject>

@optional
- (void)queueReviewWithProduct:(nonnull BVProduct *)product;
- (void)queuePIN:(nonnull BVPIN *)pin;
- (void)queueReviewWithProductId:(nonnull NSString *)productId;

@end

@protocol BVStoreNotificationCenterObject <BVNotificationCenterObject>

@optional
- (void)queueReviewWithStoreId:(nonnull NSString *)storeId;
- (void)queueReviewWithStore:(nonnull BVStore *)store;

@end
