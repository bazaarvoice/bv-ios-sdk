//
//  NativeDemoViewController.m
//  Bazaarvoice Mobile Ads SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "NativeContentAdDemoViewController.h"
#import <BVSDK/BVAdvertising.h>
#import <QuartzCore/QuartzCore.h>

@interface NativeContentAdDemoViewController()<GADNativeContentAdLoaderDelegate>

@property BVTargetedAdLoader* adLoader;

@end

@implementation NativeContentAdDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Test adUnitId. Replace with your targeted adUnitId.
    self.adLoader = [[BVTargetedAdLoader alloc]
                     initWithAdUnitID:@"/6499/example/native"
                     rootViewController:self
                     adTypes:@[ kGADAdLoaderAdTypeNativeContent ]
                     options:nil];
    
    [self.adLoader setDelegate:self];
    BVTargetedRequest* request = [self.adLoader getTargetedRequest];
    request.testDevices = @[ kGADSimulatorID ];
    
    [self.adLoader loadRequest:request];
}


#pragma mark - GADNativeContentAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    
    // configure our native content ad view with the given values, and display!
    
    BVTargetedNativeContentAdView* contentAdView =
    [[[NSBundle mainBundle] loadNibNamed:@"NativeContentAdView"
                                   owner:nil
                                 options:nil] firstObject];
    
    // Associate the app install ad view with the app install ad object.
    // This is required to make the ad clickable.
    contentAdView.nativeContentAd = nativeContentAd;
    
    // Populate the app install ad view with the app install ad assets.
    ((UIImageView *)contentAdView.logoView).image = nativeContentAd.logo.image;
    ((UIImageView *)contentAdView.imageView).image = ((GADNativeAdImage *)[nativeContentAd.images firstObject]).image;
    ((UILabel *)contentAdView.headlineView).text = nativeContentAd.headline;
    ((UILabel *)contentAdView.advertiserView).text = nativeContentAd.advertiser;
    ((UILabel *)contentAdView.bodyView).text = nativeContentAd.body;
    [((UIButton *)contentAdView.callToActionView) setTitle:nativeContentAd.callToAction forState:UIControlStateNormal];
    
    // In order for the SDK to process touch events properly, user interaction
    // should be disabled on UIButtons. Must be disabled in nib -- just highlighted here for completeness.
    contentAdView.callToActionView.userInteractionEnabled = NO;
    
    // size appropriately
    CGFloat padding = self.view.bounds.size.width * 0.1;
    contentAdView.frame = CGRectMake(padding,
                                     self.view.bounds.size.height * 0.18,
                                     self.view.bounds.size.width - padding*2,
                                     self.view.bounds.size.height * 0.4);
    
    // Add appInstallAdView to the view controller's view..
    [self.view addSubview:contentAdView];
    
    
    
    
    
    // add a border and shadow, just to highlight in this demo application
    contentAdView.layer.borderColor = [[UIColor grayColor] CGColor];
    contentAdView.layer.borderWidth = 0.5;
    contentAdView.layer.cornerRadius = 2;
    contentAdView.layer.shadowColor = [[UIColor grayColor] CGColor];
    contentAdView.layer.shadowOffset = CGSizeMake(0,5);
    contentAdView.layer.shadowRadius = 5;
    contentAdView.layer.shadowOpacity = 0.6;
    contentAdView.layer.masksToBounds = NO;
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[NSString stringWithFormat:@"Failed to get ad: %@", error]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (IBAction)closeButtonPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
