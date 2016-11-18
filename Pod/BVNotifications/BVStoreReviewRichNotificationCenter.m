//
//  BVReviewNotificationCenter.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVStoreReviewRichNotificationCenter.h"
#import "BVNotificationConstants.h"
#import "BVLogger.h"
#import "BVSDKManager.h"
#import "BVProductDisplayPageRequest.h"
#import "BVBulkStoreItemsRequest.h"
#import <MapKit/MapKit.h>
#import "BVNotificationConstants.h"
#import "BVNotificationsAnalyticsHelper.h"
#import "BVNotificationConstants.h"
#import "BVStoreNotificationConfigurationLoader.h"

@implementation BVStoreReviewRichNotificationCenter

-(id)init {
    self = [super init];
    
    if (self) {
        NSFileManager *mngr = [NSFileManager defaultManager];
        BOOL isDir;
        if (![mngr fileExistsAtPath:ATTACHMENT_FILE_DIRECTORY isDirectory:&isDir]) {
            [mngr createDirectoryAtPath:ATTACHMENT_FILE_DIRECTORY withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    
    return self;
}

- (void)addNotificationCategories:(BVStoreReviewNotificationProperties *)notificationProperties {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNNotificationAction *replyAction = [UNNotificationAction actionWithIdentifier:ID_REPLY title:notificationProperties.reviewPromptYesReview options:0];
    UNNotificationAction *remindAction = [UNNotificationAction actionWithIdentifier:ID_REMIND title:notificationProperties.reviewPromptRemindText options:0];
    UNNotificationAction *dismissAction = [UNNotificationAction actionWithIdentifier:ID_DISMISS title:notificationProperties.reviewPromtNoReview options:0];
    
    NSArray *notificationActions = @[ replyAction, remindAction, dismissAction ];
    
    UNNotificationCategory *reviewStoreCategory = [UNNotificationCategory categoryWithIdentifier: STORE_NOTIFICATION_CUSTOM_CATEGORY actions:notificationActions intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    NSSet *categories = [NSSet setWithObject:reviewStoreCategory];
    
    [center setNotificationCategories:categories];
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

-(UNNotificationAttachment *)createMapSnapshot:(BVStore *)store{
    BVStoreReviewNotificationProperties *noteProps = [[BVStoreNotificationConfigurationLoader sharedManager] bvStoreReviewNotificationProperties];
    
    if (noteProps == nil) {
        [[BVLogger sharedLogger] error:@"Unable to create notification with nil BVStoreReviewNotificationProperties. Bad network connection or missing properties config?"];
        return nil;
    }

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:@"mapThumbnail" inBundle:bundle compatibleWithTraitCollection:nil];
    NSError *error;
    NSData *data = UIImagePNGRepresentation(image);
    NSURL *fileUrl = [NSURL fileURLWithPath:ATTACHMENT_FILE_PATH];
    [data writeToURL:fileUrl options:0 error:nil];
    UNNotificationAttachment *imgAttachment = [UNNotificationAttachment attachmentWithIdentifier:ATTACHMENT_THUMB_ID URL:fileUrl options:nil error: &error];
    
    return imgAttachment;
}

-(void)rescheduleNotification:(NSDictionary *)productDict includes:(NSDictionary *)includes noteProps:(BVStoreReviewNotificationProperties *)noteProps {
    BVStore *store = [[BVStore alloc] initWithApiResponse:productDict];
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(store.storeLocation.latitude.floatValue,
                                                                                  store.storeLocation.longitude.floatValue),
                                                       MKCoordinateSpanMake(0.003, 0.003));
    UNNotificationAttachment *attachment = [self createMapSnapshot:store];
    [self scheduleRichNotification:noteProps attachments:@[attachment] store:store region:region];
}

- (void)scheduleRichNotification:(BVStoreReviewNotificationProperties *)noteProps attachments:(NSArray<UNNotificationAttachment *> *)attachments store:(BVStore*)store region:(MKCoordinateRegion)region {
    [self addNotificationCategories:noteProps];
    NSTimeInterval delay = noteProps.notificationDelay;
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:noteProps.reviewPromtDispayText arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:noteProps.reviewPromptSubtitleText
                                                         arguments:nil];
    content.categoryIdentifier = STORE_NOTIFICATION_CUSTOM_CATEGORY;
    content.attachments = attachments;
    content.userInfo = @{USER_INFO_LAT: @(region.center.latitude), USER_INFO_LONG: @(region.center.longitude),
                         USER_INFO_LAT_DELTA: @(region.span.latitudeDelta), USER_INFO_LONG_DELTA: @(region.span.longitudeDelta),
                         USER_INFO_PROD_ID: store.identifier,
                         USER_INFO_PROD_NAME: store.name,
                         USER_INFO_PROD_IMAGE_URL: store.imageUrl,
                         USER_INFO_URL_SCHEME: noteProps.customUrlScheme,
                         USER_INFO_API_KEY_CONVERSATIONS: [[BVSDKManager sharedManager] apiKeyConversationsStores],
                                                  USER_INFO_CLIENTID: [[BVSDKManager sharedManager] clientId],
                         USER_INFO_CONFIG_PROPS: [[BVStoreNotificationConfigurationLoader sharedManager] bvStoreReviewNotificationProperties].configDict};
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:delay repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"com.bazaarvoice.store.review"
                                                                          content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"add NotificationRequest succeeded!");
            [BVNotificationsAnalyticsHelper queueAnalyticEventForReviewNotificationInView:@"StoreReviewPushNotification" withId:store.identifier andProductType:ProductTypeStore];
        }
    }];
}

- (void)queueReviewWithStoreId:(nonnull NSString *)storeId {
    
    [self loadStoreInfo:storeId completion:^(BVStore * _Nullable store) {
        if (store) {
            [self queueReviewWithStore:store];
        }
    }];
}

- (void)queueReviewWithStore:(nonnull BVStore *)store {
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(store.storeLocation.latitude.floatValue,
                                                                                  store.storeLocation.longitude.floatValue),
                                                                                  MKCoordinateSpanMake(0.003, 0.003));
    UNNotificationAttachment *attachment = [self createMapSnapshot:store];
    if (attachment) {
        [self scheduleRichNotification:[[BVStoreNotificationConfigurationLoader sharedManager] bvStoreReviewNotificationProperties] attachments:@[attachment] store:store region:region];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter* _Nonnull)center didReceiveNotificationResponse:(UNNotificationResponse * _Nonnull)response {
    
    NSString *storeId = response.notification.request.content.userInfo[USER_INFO_PROD_ID];
    
    if ([[response actionIdentifier] isEqualToString:ID_REPLY] ||
        [response.actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]){
        
        [BVNotificationsAnalyticsHelper queueAnalyticEventForReviewUsedFeature:ID_REPLY withId:storeId andProductType:ProductTypeStore];
        
    } else if ([[response actionIdentifier] isEqualToString:ID_REMIND]){
        
        //not yet handled; should maybe reschedule
        [BVNotificationsAnalyticsHelper queueAnalyticEventForReviewUsedFeature:ID_REMIND withId:storeId andProductType:ProductTypeStore];
        [self queueReviewWithStoreId:storeId];
        
    } else if ([[response actionIdentifier] isEqualToString:ID_DISMISS] ||
               [response.actionIdentifier isEqualToString:UNNotificationDismissActionIdentifier]){
        
        // User cancelled. Client can determine whether or not to cache this store to not show again.
        [BVNotificationsAnalyticsHelper queueAnalyticEventForReviewUsedFeature:ID_DISMISS withId:storeId andProductType:ProductTypeStore];
    }
    
}

- (void)handleActionWithIdentifier:(NSString * _Nullable)identifier forLocalNotification:(UILocalNotification * _Nonnull)notification {
    
}

@end
