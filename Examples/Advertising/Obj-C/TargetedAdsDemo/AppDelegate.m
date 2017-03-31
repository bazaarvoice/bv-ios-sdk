//
//  AppDelegate.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
@import BVSDK;


@implementation AppDelegate
    
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupWindow];
    
    
#warning Add your own bvsdk_config files to project
    
    // Configure BVSDKManager
    [BVSDKManager configure:BVConfigurationTypeStaging];
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelError];
    
    // Next, we have to tell BVSDK about the user.
    // See the BVSDK wiki for more discussion on how to create this user auth string: https://github.com/bazaarvoice/bv-ios-sdk/wiki/BVSDK-UserAuthentication
    // A user auth string would contain data in a query string format. For example:
    //     userid=Example&email=user@example.com&age=28&gender=female&facebookId=123abc
    
    
    // Example auth string used, pre-populated with a small profile interested in "pets",
    //     "powersports", "gamefish", and others -- for testing purposes.
    [[BVSDKManager sharedManager] setUserWithAuthString:@"0ce436b29697d6bc74f30f724b9b0bb6646174653d31323334267573657269643d5265636f6d6d656e646174696f6e7353646b54657374"];
    
    NSString *myClientId = [[[BVSDKManager sharedManager]configuration]clientId];
    NSString *myShopperAdvertisingKey = [[[BVSDKManager sharedManager]configuration]apiKeyShopperAdvertising];
    if ([myClientId isEqualToString:@"REPLACE_ME"] || [myShopperAdvertisingKey isEqualToString:@"REPLACE_ME"]){
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
    NSString* alertMessage = @"Make sure you have set your API Key and Client ID in project files bvsdk_config_prod.json and bvsdk_config_staging.json . Please contact Bazaarvoice if you do not have an API key.";
    
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
