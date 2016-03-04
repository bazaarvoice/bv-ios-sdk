//
//  AppDelegate.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchViewController.h"

#import <BVSDK/BVConversations.h>

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Here we set the background image for the entire application
    if(self.window.bounds.size.height > 480){
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"app-background-586.png"]];
    } else {
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"app-background.png"]];        
    }
    
    self.window.rootViewController = [self getRootViewController];
    [self.window makeKeyAndVisible];
    
    #warning Configure the BVSDK with your client Id and API key!!!
    NSString *myClientId = nil; // INSERT YOUR CLIEND ID!!!!
    NSString *myConversationsAPIKey = nil; // INSERT YOUR CONVERSATIONS API KEY!!!
    
    if (myClientId != nil && myConversationsAPIKey != nil){
        // Global BV SDK setup.  In general this should only occur once
        [BVSDKManager sharedManager].apiKeyConversations = myConversationsAPIKey;
        [BVSDKManager sharedManager].clientId = myClientId;
        [BVSDKManager sharedManager].staging = YES;
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

-(UIViewController*)getRootViewController {
    
    return (SearchViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
