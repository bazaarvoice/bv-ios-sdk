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
    
#warning Add your Conversations API key and client id below!
    [BVSDKManager sharedManager].clientId = @"apitestcustomer";
    [BVSDKManager sharedManager].apiKeyConversations = @"kuy3zj9pr3n7i0wxajrzj04xo";
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelVerbose];
    [BVSDKManager sharedManager].staging = true;
    
    return YES;
}

@end
