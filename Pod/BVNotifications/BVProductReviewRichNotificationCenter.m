//
//  BVProuductReviewRichNotificationCenter.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVProductReviewRichNotificationCenter.h"
#import "BVNotificationConstants.h"
#import "BVSDKManager.h"
#import "BVProduct.h"
#import "BVProductDisplayPageRequest.h"
#import "BVNotificationsAnalyticsHelper.h"
#import "BVPIN.h"
#import "BVConversationsInclude.h"
#import "BVProductReviewNotificationProperties.h"
#import "BVProductReviewNotificationConfigurationLoader.h"
#import "BVSDKConfiguration.h"

@implementation BVProductReviewRichNotificationCenter

- (void)addNotificationCategories:(BVProductReviewNotificationProperties *)notificationProperties {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNNotificationAction *replyAction = [UNNotificationAction actionWithIdentifier:ID_REPLY title:notificationProperties.reviewPromptYesReview options: UNNotificationActionOptionNone];
    UNNotificationAction *remindAction = [UNNotificationAction actionWithIdentifier:ID_REMIND title:notificationProperties.reviewPromptRemindText options:UNNotificationActionOptionNone];
    UNNotificationAction *dismissAction = [UNNotificationAction actionWithIdentifier:ID_DISMISS title:notificationProperties.reviewPromtNoReview options:UNNotificationActionOptionNone];
    
    NSArray *notificationActions = @[ replyAction, remindAction, dismissAction ];
    
    UNNotificationCategory *reviewStoreCategory = [UNNotificationCategory categoryWithIdentifier:PIN_CUSTOM_CATEGORY actions:notificationActions intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    NSSet *categories = [NSSet setWithObject:reviewStoreCategory];
    
    [center setNotificationCategories:categories];
}


- (void)queueReviewWithProductId:(nonnull NSString *)productId {
    [self loadProductInfo:productId completion:^(BVProduct * _Nullable product) {
        if (product) {
            [self queueProductReview:[[BVProductReviewNotificationConfigurationLoader sharedManager] bvProductReviewNotificationProperties] product:product];
        }
    }];
}

-(void)queueReviewWithProduct:(BVProduct *)product {
    [self queueProductReview:[[BVProductReviewNotificationConfigurationLoader sharedManager] bvProductReviewNotificationProperties] product:product];
}

-(void)queuePIN:(BVPIN *)pin {
    [self loadProductInfo:pin.identifier completion:^(BVProduct * _Nullable product) {
        if (product) {
            [self queueProductReview:[[BVProductReviewNotificationConfigurationLoader sharedManager] bvProductReviewNotificationProperties] product:product];
        }
    }];
}

- (void)rescheduleNotification:(NSDictionary *)productDict includes:(NSDictionary *)includes noteProps:(BVNotificationProperties *)noteProps {
    BVConversationsInclude *include = [[BVConversationsInclude alloc] initWithApiResponse:includes];
    BVProduct *product = [[BVProduct alloc] initWithApiResponse:productDict includes:include];
    [self queueProductReview:(BVProductReviewNotificationProperties*)noteProps product:product];
}

- (void)queueProductReview:(BVProductReviewNotificationProperties*)noteProps product:(BVProduct*)product {
    
    if (![noteProps notificationsEnabled]) {
        return;
    }
    [self addNotificationCategories:noteProps];

    NSTimeInterval delay = noteProps.notificationDelay;
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:noteProps.reviewPromtDispayText arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:noteProps.reviewPromptSubtitleText
                                                         arguments:nil];
    content.categoryIdentifier = PIN_CUSTOM_CATEGORY;
    content.userInfo = @{USER_INFO_PROD_ID: product.identifier,
                         USER_INFO_PROD_NAME: product.name,
                         USER_INFO_PROD_IMAGE_URL: product.imageUrl,
                         USER_INFO_URL_SCHEME: noteProps.customUrlScheme,
                         USER_INFO_API_KEY_CONVERSATIONS: [BVSDKManager sharedManager].configuration.apiKeyConversations,
                         USER_INFO_CLIENTID: [BVSDKManager sharedManager].configuration.clientId,
                         USER_INFO_CONFIG_PROPS: noteProps.configDict};
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:delay repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"com.bazaarvoice.store.review"
                                                                          content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            [BVNotificationsAnalyticsHelper queueAnalyticEventForReviewNotificationInView:@"PINPushNotification" withId:product.identifier andProductType:ProductTypeProduct];
        }
    }];

}

- (void)loadProductInfo:(NSString*)productId completion:(void (^_Nonnull)(BVProduct * _Nullable product))completion{
    
    BVProductDisplayPageRequest *request = [[BVProductDisplayPageRequest alloc] initWithProductId:productId];
    [request load:^(BVProductsResponse * _Nonnull response) {
        
        BVProduct* store = response.result;
        completion(store);
        
    } failure:^(NSArray * _Nonnull errors) {
        [[BVLogger sharedLogger] printErrors:errors];
    }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter* _Nonnull)center didReceiveNotificationResponse:(UNNotificationResponse * _Nonnull)response {
}


@end