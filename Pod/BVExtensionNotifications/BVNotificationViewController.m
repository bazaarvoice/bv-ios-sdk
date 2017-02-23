//
//  BVNotificationViewController.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.

#import "BVNotificationViewController.h"
#import "BVNotificationsAnalyticsHelper.h"
#import "BVAnalyticEventManager.h"

@interface BVNotificationViewController (Private)
-(ProductType)getProductType;
@end

@implementation BVNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion {
    NSString *Id = response.notification.request.content.userInfo[USER_INFO_PROD_ID];

    if ([[response actionIdentifier] isEqualToString:ID_REPLY] ||
        [response.actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]){
        
        NSString *urlscheme = [NSString stringWithFormat:@"%@://www.bvsdk.com?type=review&subtype=%@&id=%@", response.notification.request.content.userInfo[USER_INFO_URL_SCHEME], ([self getProductType] == ProductTypeStore)? @"store" : @"product", Id];
        [self.extensionContext openURL:[NSURL URLWithString: urlscheme] completionHandler:nil];
        
        [BVNotificationsAnalyticsHelper queueAnalyticEventForReviewUsedFeature:ID_REPLY withId:Id andProductType:[self getProductType]];
        
    } else if ([[response actionIdentifier] isEqualToString:ID_REMIND]){
        
        [BVNotificationsAnalyticsHelper queueAnalyticEventForReviewUsedFeature:ID_REMIND withId:Id andProductType:[self getProductType]];
        
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:response.notification.request withCompletionHandler:^(NSError *error) {
                 
        }];
    
    } else if ([[response actionIdentifier] isEqualToString:ID_DISMISS] ||
                      [response.actionIdentifier isEqualToString:UNNotificationDismissActionIdentifier]){
        
        [BVNotificationsAnalyticsHelper queueAnalyticEventForReviewUsedFeature:ID_DISMISS withId:Id andProductType:[self getProductType]];
    }
    
    completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
}

- (void)didReceiveNotification:(UNNotification *)notification{
    [[BVAnalyticEventManager sharedManager] setClientId:notification.request.content.userInfo[USER_INFO_CLIENTID]];
}

-(void)launchAppWithType:(NSString*)type subtype:(NSString*)subtype ID:(NSString*)ID {
    
}

@end
