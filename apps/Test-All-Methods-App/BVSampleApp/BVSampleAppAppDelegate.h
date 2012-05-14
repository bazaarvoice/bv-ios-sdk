//
//  BVSampleAppAppDelegate.h
//  BVSampleApp
//
//  Created by Bazaarvoice Engineering on 3/10/12.
//  Copyright (c) 2012 Bazaarvoice Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BVSampleAppMainViewController;

@interface BVSampleAppAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BVSampleAppMainViewController *mainViewController;
@property (strong, nonatomic) UINavigationController *mainNavController;

@end