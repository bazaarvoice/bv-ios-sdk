//
//  AppDelegate.m
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "AppDelegate.h"
#import <BVSDK/BVConversations.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
#warning Add your Conversations API key and client id below!
    [BVSDKManager sharedManager].clientId = @"apitestcustomer";
    [BVSDKManager sharedManager].apiKeyConversations = @"KEY_REMOVED";
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelVerbose];
    [BVSDKManager sharedManager].staging = true;
    
    return YES;
}

@end