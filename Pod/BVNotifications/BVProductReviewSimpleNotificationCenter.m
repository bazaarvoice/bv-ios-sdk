//
//  BVProductReviewSimpleNotificationCenter.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVProductReviewSimpleNotificationCenter.h"
#import "BVProductReviewNotificationProperties.h"
#import "BVNotificationConstants.h"
#import "BVProductDisplayPageRequest.h"
#import "BVLogger.h"
#import "BVConversationsInclude.h"
#import "BVSDKManager.h"
#import "BVProductReviewNotificationConfigurationLoader.h"
#import "BVSDKConfiguration.h"

@implementation BVProductReviewSimpleNotificationCenter

- (void)queueReviewWithProduct:(nonnull BVProduct *)product {
    [self queueProductReview:[[BVProductReviewNotificationConfigurationLoader sharedManager] bvProductReviewNotificationProperties] product:product];
}

- (void)queuePIN:(nonnull BVPIN *)pin {
    [self queueReviewWithProductId:pin.identifier];
}

- (void)queueReviewWithProductId:(nonnull NSString *)productId {
    [self loadProductInfo:productId completion:^(BVProduct * _Nullable product) {
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

-(void)queueProductReview:(BVProductReviewNotificationProperties*)noteProps product:(BVProduct*)product {
    [self addNotificationCategories:noteProps];
    
    NSTimeInterval delay = noteProps.notificationDelay;
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];
    notification.alertBody = noteProps.reviewPromtDispayText;
    notification.category = PIN_CUSTOM_CATEGORY;
    notification.userInfo = @{USER_INFO_PROD_ID: product.identifier,
                              USER_INFO_PROD_NAME: product.name,
                              USER_INFO_PROD_IMAGE_URL: product.imageUrl,
                              USER_INFO_URL_SCHEME: noteProps.customUrlScheme};
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)addNotificationCategories:(BVProductReviewNotificationProperties * _Nonnull)notificationProperties {
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
    category.identifier = PIN_CUSTOM_CATEGORY;
    [category setActions:@[replyAction, noAction] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *cats = [NSSet setWithObjects:category, nil];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:cats];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
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

-(void)handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification {
    
}

@end
