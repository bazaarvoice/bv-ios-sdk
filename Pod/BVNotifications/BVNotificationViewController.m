//
//  BVNotificationViewController.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.

#import "BVNotificationViewController.h"
#import "BVNotificationsAnalyticsHelper.h"
#import "BVReviewRichNotificationCenter.h"

@interface BVNotificationViewController()<UNNotificationContentExtension>

@property (nonatomic, strong) BVReviewRichNotificationCenter *notificationCenter;

@end

@implementation BVNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _notificationCenter = [[BVReviewRichNotificationCenter alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion {
    
    NSString *storeId = response.notification.request.content.userInfo[USER_INFO_PROD_ID];
    
    if ([[response actionIdentifier] isEqualToString:ID_REPLY] ||
        [response.actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]){
        
        NSString *urlscheme = [NSString stringWithFormat:@"%@://www.bvsdk.com?type=review&subtype=store&id=%@", response.notification.request.content.userInfo[USER_INFO_URL_SCHEME], storeId];
        [self.extensionContext openURL:[NSURL URLWithString: urlscheme] completionHandler:nil];
          //analytic event
        [[BVNotificationsAnalyticsHelper instance] queueAnalyticEventForStoreReviewUsedFeature:ID_REPLY withStoreId:storeId];
        
    } else if ([[response actionIdentifier] isEqualToString:ID_REMIND]){
        
        [[BVNotificationsAnalyticsHelper instance] queueAnalyticEventForStoreReviewUsedFeature:ID_REMIND withStoreId:storeId];
        //analytic event
        [_notificationCenter queueStoreReview:storeId];
        
    } else if ([[response actionIdentifier] isEqualToString:ID_DISMISS] ||
                      [response.actionIdentifier isEqualToString:UNNotificationDismissActionIdentifier]){
        //analytic event
        [[BVNotificationsAnalyticsHelper instance] queueAnalyticEventForStoreReviewUsedFeature:ID_DISMISS withStoreId:storeId];
    }
    
    completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
}


@end
