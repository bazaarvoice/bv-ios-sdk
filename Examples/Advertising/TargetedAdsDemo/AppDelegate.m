//
//  AppDelegate.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <BVSDK/BVSDK.h>


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setupWindow];
    
    
    #warning ADD YOUR CLIENT ID AND SHOPPER ADVERTISING KEY HERE!!!
    NSString *myClientId = @"REPLACE_ME";              // INSERT YOUR CLIEND ID!!!!
    NSString *myShopperAdvertisingKey = @"REPLACE_ME"; // INSERT YOUR SHOPPER ADVERTISING KEY!!!
    
    
    if (![myClientId isEqualToString:@"REPLACE_ME"] && ![myShopperAdvertisingKey isEqualToString:@"REPLACE_ME"]){
    
        
        // Configure BVSDKManager
        [[BVSDKManager sharedManager] setClientId:myClientId];
        [[BVSDKManager sharedManager] setApiKeyShopperAdvertising:myShopperAdvertisingKey];
        [[BVSDKManager sharedManager] setLogLevel:BVLogLevelError];
        
        
        // Set BVAdvertising to staging for testing and development. Set to NO for release.
        [[BVSDKManager sharedManager] setStaging:YES];

        
        
        // Next, we have to tell BVSDK about the user.
        // See the BVSDK wiki for more discussion on how to create this user auth string: https://github.com/bazaarvoice/bv-ios-sdk/wiki/BVSDK-UserAuthentication
        // A user auth string would contain data in a query string format. For example:
        //     userid=Example&email=user@example.com&age=28&gender=female&facebookId=123abc
        
        
        // Example auth string used, pre-populated with a small profile interested in "pets",
        //     "powersports", "gamefish", and others -- for testing purposes.
        [[BVSDKManager sharedManager] setUserWithAuthString:@"TOKEN_REMOVED"];
        
    } else {
        
        [self showNotConfiguredError];
        
    }
    
    return YES;
}

-(void)setupWindow {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO]; // set status bar color
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];
    [navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [navigationController.navigationBar setTranslucent:NO];
    [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    
}

-(void)showNotConfiguredError {
    
    NSString* alertTitle = @"BVSDK Not Configured";
    NSString* alertMessage = @"Make sure you have set your API Key and Client ID in AppDelegate.m. Please contact Bazaarvoice if you do not have an API key.";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) { exit(1); }];
    
    [alert addAction:okAction];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}

@end
