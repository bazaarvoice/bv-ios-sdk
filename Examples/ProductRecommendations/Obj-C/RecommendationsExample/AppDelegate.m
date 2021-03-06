//
//  AppDelegate.m
//  RecommendationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "AppDelegate.h"
@import BVSDK;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#warning See bvsdk_config_staging.json and bvsdk_config_product.json in the project for API key and client ID settings.
  [BVSDKManager configure:BVConfigurationTypeProd];
  [[BVSDKManager sharedManager] setLogLevel:BVLogLevelVerbose];

  // Example of hard-coded UAS token to set a user's profile
  [[BVSDKManager sharedManager]
      setUserWithAuthString:@"0ce436b29697d6bc74f30f724b9b0bb6646174653d3132333"
                            @"4267573657269643d5265636f6d6d656e646174696f6e7353"
                            @"646b54657374"];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state. Use this method to
  // pause ongoing tasks, disable timers, and throttle down OpenGL ES frame
  // rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later. If your
  // application supports background execution, this method is called instead of
  // applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

@end
