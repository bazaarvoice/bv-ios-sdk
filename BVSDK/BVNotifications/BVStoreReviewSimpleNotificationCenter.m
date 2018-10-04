//
//  BVReviewSimpleNotificationCenter.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVStoreReviewSimpleNotificationCenter.h"
#import "BVBulkStoreItemsRequest.h"
#import "BVConversationsInclude.h"
#import "BVNotificationConstants.h"
#import "BVNotificationsAnalyticsHelper.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager+Private.h"
#import "BVStoreNotificationConfigurationLoader.h"
#import "BVStoreReviewNotificationProperties.h"
#import <UserNotifications/UserNotifications.h>

@implementation BVStoreReviewSimpleNotificationCenter

- (void)userNotificationCenter:(nonnull UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response {
}

- (void)handleActionWithIdentifier:(nullable NSString *)identifier
              forLocalNotification:(nonnull UILocalNotification *)notification {
  NSString *storeId = notification.userInfo[USER_INFO_PROD_ID];

  if ([identifier isEqualToString:ID_REPLY]) {
    [BVNotificationsAnalyticsHelper
        queueAnalyticEventForReviewUsedFeature:ID_REPLY
                                        withId:storeId
                                andProductType:ProductTypeStore];
  } else if ([identifier isEqualToString:ID_REMIND]) {
    // not yet handled; should maybe reschedule
    [BVNotificationsAnalyticsHelper
        queueAnalyticEventForReviewUsedFeature:ID_REMIND
                                        withId:storeId
                                andProductType:ProductTypeStore];
  } else if ([identifier isEqualToString:ID_DISMISS]) {
    // not yet handled; should persist decision to not review and not prompt
    // again
    [BVNotificationsAnalyticsHelper
        queueAnalyticEventForReviewUsedFeature:ID_DISMISS
                                        withId:storeId
                                andProductType:ProductTypeStore];
  }
}

- (void)queueReviewWithStoreId:(nonnull NSString *)storeId {
  [self loadStoreInfo:storeId
           completion:^(BVStore *store) {
             if (store) {
               [self queueReviewWithStore:store];
             }
           }];
}

- (void)loadStoreInfo:(NSString *)storeId
           completion:(nonnull void (^)(BVStore *__nullable store))completion {
  BVBulkStoreItemsRequest *request =
      [[BVBulkStoreItemsRequest alloc] initWithStoreIds:@[ storeId ]];
  [request load:^(BVBulkStoresResponse *__nonnull response) {

    BVStore *store = response.results.firstObject;
    completion(store);

  }
      failure:^(NSArray *__nonnull errors) {
        [[BVLogger sharedLogger] printErrors:errors];
      }];
}

- (void)queueReviewWithStore:(nonnull BVStore *)store {
  [self scheduleNotification:[[BVStoreNotificationConfigurationLoader
                                 sharedManager]
                                 bvStoreReviewNotificationProperties]
                       store:store];
}

- (void)rescheduleNotification:(NSDictionary *)productDict
                      includes:(NSDictionary *)includes
                     noteProps:
                         (BVStoreReviewNotificationProperties *)noteProps {
  BVStore *store = [[BVStore alloc] initWithApiResponse:productDict];
  [self scheduleNotification:noteProps store:store];
}

- (void)scheduleNotification:(BVStoreReviewNotificationProperties *)noteProps
                       store:(BVStore *)store {
  [self addNotificationCategories:noteProps];

  NSTimeInterval delay = noteProps.notificationDelay;

  UILocalNotification *notification = [[UILocalNotification alloc] init];
  notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];
  notification.alertBody = noteProps.reviewPromtDispayText;
  notification.category = STORE_NOTIFICATION_CUSTOM_CATEGORY;
  notification.userInfo = @{
    USER_INFO_PROD_ID : store.identifier,
    USER_INFO_PROD_NAME : store.name,
    USER_INFO_PROD_IMAGE_URL : store.imageUrl,
    USER_INFO_URL_SCHEME : noteProps.customUrlScheme
  };
  [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)addNotificationCategories:
    (nonnull BVStoreReviewNotificationProperties *)notificationProperties {
  UIUserNotificationType type = UIUserNotificationTypeAlert |
                                UIUserNotificationTypeBadge |
                                UIUserNotificationTypeSound;
  UIMutableUserNotificationAction *replyAction =
      [UIMutableUserNotificationAction new];
  replyAction.identifier = ID_REPLY;
  replyAction.title = notificationProperties.reviewPromptYesReview;
  replyAction.activationMode = UIUserNotificationActivationModeForeground;
  replyAction.destructive = NO;
  replyAction.authenticationRequired = NO;

  UIMutableUserNotificationAction *noAction =
      [UIMutableUserNotificationAction new];
  noAction.identifier = ID_DISMISS;
  noAction.title = notificationProperties.reviewPromtNoReview;
  noAction.activationMode = UIUserNotificationActivationModeBackground;
  noAction.destructive = NO;
  noAction.authenticationRequired = NO;

  UIMutableUserNotificationCategory *category =
      [UIMutableUserNotificationCategory new];
  category.identifier = STORE_NOTIFICATION_CUSTOM_CATEGORY;
  [category setActions:@[ replyAction, noAction ]
            forContext:UIUserNotificationActionContextDefault];

  NSSet *cats = [NSSet setWithObjects:category, nil];

  UIUserNotificationSettings *settings =
      [UIUserNotificationSettings settingsForTypes:type categories:cats];
  [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

@end
