//
//  BannerDemoViewController.m
//  Bazaarvoice Mobile Ads SDK - Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BannerDemoViewController.h"
@import BVSDK;

@implementation BannerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.bannerView.adUnitID = @"/6499/example/banner"; //Test adUnitId. Replace with your targeted adUnitId.
    self.bannerView.rootViewController = self;
    
    DFPRequest* request = [DFPRequest request];
    request.testDevices = @[ kGADSimulatorID ];
    request.customTargeting = [[BVSDKManager sharedManager] getCustomTargeting];
    [self.bannerView loadRequest:request];

    [self.view addSubview:self.bannerView];
}

- (IBAction)closeButtonPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
