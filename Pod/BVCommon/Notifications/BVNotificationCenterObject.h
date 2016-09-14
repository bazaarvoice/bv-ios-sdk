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
#define NOTIFICATION_CUSTOM_CATEGORY    [[BVSDKManager sharedManager] storeReviewContentExtensionCategory]
#define NOTIFICATION_CATEGORY           @"reviewCategory"

#import "BVStoreReviewNotificationProperties.h"
#import "BVStore.h"
#import <UserNotifications/UserNotifications.h>

@protocol BVNotificationCenterObject <NSObject>

- (void)addNotificationCategories:(BVStoreReviewNotificationProperties * _Nonnull)notificationProperties;

- (void)userNotificationCenter:(UNUserNotificationCenter* _Nonnull)center didReceiveNotificationResponse:(UNNotificationResponse * _Nonnull)response;

- (void)handleActionWithIdentifier:(NSString * _Nullable)identifier forLocalNotification:(UILocalNotification * _Nonnull)notification;

- (void)queueStoreReview:(nonnull NSString *)storeId;
- (void)queueStoreReviewWithStore:(nonnull BVStore *)store;

@end
