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
    return YES;
}

@end
