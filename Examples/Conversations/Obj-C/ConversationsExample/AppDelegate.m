//
//  AppDelegate.m
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "AppDelegate.h"
@import BVSDK;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
#warning See bvsdk_config_staging.json and bvsdk_config_product.json in the project for API key and client ID settings.
    [BVSDKManager configure:BVConfigurationTypeStaging];
    
    return YES;
}

@end
