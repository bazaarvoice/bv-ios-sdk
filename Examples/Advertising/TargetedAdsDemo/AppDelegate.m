//
//  AppDelegate.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <BVSDK/BVAdvertising.h>
#import "AppDelegate.h"
#import "RootViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // set status bar color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.window.rootViewController = [self getRootViewController];
    [self.window makeKeyAndVisible];
    
    NSString *myClientId = nil;              // INSERT YOUR CLIEND ID!!!!
    NSString *myShopperAdvertisingKey = nil; // INSERT YOUR SHOPPER ADVERTISING KEY!!!
    
    if (myClientId != nil && myShopperAdvertisingKey != nil){
    
        // set up the BVAdsSDK with your clientId, and AdsPassKey
        [[BVSDKManager sharedManager] setClientId:myClientId];
        [[BVSDKManager sharedManager] setApiKeyShopperAdvertising:myShopperAdvertisingKey];
        [[BVSDKManager sharedManager] setLogLevel:BVLogLevelInfo];
        
        // set BVAdvertising to staging for testing and development.
        [[BVSDKManager sharedManager] setStaging:YES];

        /*
            Next, we have to tell BVSDK about the user. See the BVSDK wiki for more discussion on how to create this user auth string: https://github.com/bazaarvoice/bv-ios-sdk/wiki/BVSDK-UserAuthentication
         
            A user auth string would contain data in a query string format. For example:
            userid=Example&email=user@example.com&age=28&gender=female&facebookId=123abc
         */
        
        // Example MD5 encoded auth string used
        [[BVSDKManager sharedManager] setUserWithAuthString:@"aa05cf391c8d4738efb4d05f7b2ad7ce7573657269643d4f6d6e694368616e6e656c50726f66696c65313226656d61696c3d6a61736f6e406a61736f6e2e636f6d"]; // pre-populated with a small profile interested in "pets", "powersports", "gamefish", and others -- for testing purposes.
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BVSDK Not Configured" message:@"Make sure you have set your API Key and Client ID in AppDelegate.m. Please contact Bazaarvoice if you need an evaluation key." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // completion
            exit(1);
        }];
        
        [alert addAction:okAction];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:^{
        }];
        
    }
    
    return YES;
}

-(UINavigationController*)getRootViewController {
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];
    [navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [navigationController.navigationBar setTranslucent:NO];
    [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    return navigationController;
}

@end
