//
//  AppDelegate.m
//  CurationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "AppDelegate.h"
@import BVSDK;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#warning See bvsdk_config_staging.json and bvsdk_config_product.json in the project for API key and client ID settings.
    [BVSDKManager configure:BVConfigurationTypeStaging];
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelVerbose];
    
    return YES;
}

@end
