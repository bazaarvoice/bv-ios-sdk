//
//  BVReviewSimpleNotificationCenter.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVReviewSimpleNotificationCenter.h"
#import "BVStoreReviewNotificationProperties.h"
#import "BVBulkStoreItemsRequest.h"
#import "BVSDKManager.h"
#import "BVNotificationsAnalyticsHelper.h"
#import <UserNotifications/UserNotifications.h>
#import "BVNotificationConstants.h"

@implementation BVReviewSimpleNotificationCenter

- (void)userNotificationCenter:(UNUserNotificationCenter* _Nonnull)center didReceiveNotificationResponse:(UNNotificationResponse * _Nonnull)response {

}

- (void)handleActionWithIdentifier:(NSString * _Nullable)identifier forLocalNotification:(UILocalNotification * _Nonnull)notification {
    if ([identifier isEqualToString:ID_REPLY]){
        [[BVNotificationsAnalyticsHelper instance] queueAnalyticEventForStoreReviewUsedFeature:ID_REPLY withStoreId:@"unknown"];
    } else if ([identifier isEqualToString:ID_REMIND]){
        //not yet handled; should maybe reschedule
        [[BVNotificationsAnalyticsHelper instance] queueAnalyticEventForStoreReviewUsedFeature:ID_REMIND withStoreId:@"unknown"];
    } else if ([identifier isEqualToString:ID_DISMISS]){
        //not yet handled; should persist decision to not review and not prompt again
        [[BVNotificationsAnalyticsHelper instance] queueAnalyticEventForStoreReviewUsedFeature:ID_DISMISS withStoreId:@"unknown"];
    }
    
}

+(instancetype _Nonnull)sharedCenter {
    static dispatch_once_t p = 0;
    
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (void)queueStoreReview:(nonnull NSString *)storeId {
    [self loadStoreInfo:storeId completion:^(BVStore *store) {
        if (store) {
            [self queueStoreReviewWithStore:store];
        }
    }];
}

- (void)loadStoreInfo:(NSString*)storeId completion:(void (^_Nonnull)(BVStore * _Nullable store))completion{
    
    BVBulkStoreItemsRequest *request = [[BVBulkStoreItemsRequest alloc] initWithStoreIds:@[storeId]];
    [request load:^(BVBulkStoresResponse * _Nonnull response) {
        
        BVStore* store = response.results.firstObject;
        completion(store);
        
    } failure:^(NSArray * _Nonnull errors) {
        [[BVLogger sharedLogger] printErrors:errors];
    }];
}

- (void)queueStoreReviewWithStore:(nonnull BVStore *)store {
    [self scheduleNotification:[[BVSDKManager sharedManager] bvStoreReviewNotificationProperties] store:store];
}

-(void)scheduleNotification:(BVStoreReviewNotificationProperties *)noteProps store:(BVStore*)store {
    [self addNotificationCategories:noteProps];
    
    NSTimeInterval delay = noteProps.notificationDelay;
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];
    notification.alertBody = noteProps.reviewPromtDispayText;
    notification.category = NOTIFICATION_CATEGORY;
    notification.userInfo = @{USER_INFO_PROD_ID: store.identifier, USER_INFO_URL_SCHEME: noteProps.customUrlScheme};
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)addNotificationCategories:(BVStoreReviewNotificationProperties * _Nonnull)notificationProperties {
    UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIMutableUserNotificationAction *replyAction = [UIMutableUserNotificationAction new];
    replyAction.identifier = ID_REPLY;
    replyAction.title = notificationProperties.reviewPromptYesReview;
    replyAction.activationMode = UIUserNotificationActivationModeForeground;
    replyAction.destructive = NO;
    replyAction.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *noAction = [UIMutableUserNotificationAction new];
    noAction.identifier = ID_DISMISS;
    noAction.title = notificationProperties.reviewPromtNoReview;
    noAction.activationMode = UIUserNotificationActivationModeBackground;
    noAction.destructive = NO;
    noAction.authenticationRequired = NO;
    
    UIMutableUserNotificationCategory *category = [UIMutableUserNotificationCategory new];
    category.identifier = NOTIFICATION_CATEGORY;
    [category setActions:@[replyAction, noAction] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *cats = [NSSet setWithObjects:category, nil];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:cats];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

@end
