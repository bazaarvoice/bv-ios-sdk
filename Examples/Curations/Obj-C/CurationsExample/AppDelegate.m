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
    
#warning Add your own Client ID and Curations API Keys!
    [[BVSDKManager sharedManager] setClientId:@"bazaarvoice"];
    [[BVSDKManager sharedManager] setApiKeyCurations:@"r538c65d7d3rsx2265tvzfje"];
    [[BVSDKManager sharedManager] setStaging:YES];  // Set to NO for production!
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelVerbose];
    
    return YES;
}

@end
