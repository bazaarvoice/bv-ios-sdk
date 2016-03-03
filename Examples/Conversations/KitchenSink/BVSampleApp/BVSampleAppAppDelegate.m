//
//  BVSampleAppAppDelegate.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//


#import "BVSampleAppAppDelegate.h"

#import "BVSampleAppMainViewController.h"

@implementation BVSampleAppAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIViewController* rootViewController = [[BVSampleAppMainViewController alloc] initWithNibName:@"BVSampleAppMainViewController" bundle:nil];

    self.mainNavController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    [self.mainNavController.navigationBar setTranslucent:NO];
    [self.mainNavController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:0.24 blue:0.3 alpha:1.0]];
    [self.mainNavController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.mainNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.window.rootViewController = self.mainNavController;
    [self.window makeKeyAndVisible];
    
    #warning Configure the BVSDK with your client id and API key!!!
    NSString *myClientId = nil; // INSERT YOUR CLIEND ID!!!!
    NSString *myConversationsAPIKey = nil; // INSERT YOUR CONVERSATIONS API KEY!!!
    
    if (myClientId != nil && myConversationsAPIKey != nil){
        // Global BV SDK setup.  In general this should only occur once
        [BVSDKManager sharedManager].apiKeyConversations = myConversationsAPIKey;
        [BVSDKManager sharedManager].clientId = myClientId;
        [BVSDKManager sharedManager].staging = YES;
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BVSDK Not Configured" message:@"Make sure you have set your API Key and Client ID in BVSampleAppAppDelegate.m. Please contact Bazaarvoice if you need an evaluation key." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // completion
            exit(1);
        }];
        
        [alert addAction:okAction];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:^{
        }];
        
    }

#ifdef IOVATION_INSTALLED
    [DevicePrint start];
#endif
    
    return YES;
}

@end
