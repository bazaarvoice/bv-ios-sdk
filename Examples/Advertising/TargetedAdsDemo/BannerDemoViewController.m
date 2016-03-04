//
//  BannerDemoViewController.m
//  Bazaarvoice Mobile Ads SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BannerDemoViewController.h"

@implementation BannerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.bannerView.adUnitID = @"/6499/example/banner"; //Test adUnitId. Replace with your targeted adUnitId.
    self.bannerView.rootViewController = self;
    
    BVTargetedRequest* request = [self.bannerView getTargetedRequest];
    request.testDevices = @[ kGADSimulatorID ];
    [self.bannerView loadRequest:request];

    [self.view addSubview:self.bannerView];
}

- (IBAction)closeButtonPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
