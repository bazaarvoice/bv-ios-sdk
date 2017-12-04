//
//  InterstitialDemo.m
//  Bazaarvoice Mobile Ads SDK - Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "InterstitialDemo.h"
@import BVSDK;

@import GoogleMobileAds;

@interface InterstitialDemo () <GADInterstitialDelegate>

@property DFPInterstitial *interstitial;
@property UIViewController *rootViewController;

@end

@implementation InterstitialDemo

- (id)initWithRootViewController:(UIViewController *)rootViewController {
  self = [super init];
  if (self) {
    self.rootViewController = rootViewController;
  }
  return self;
}

- (void)requestInterstitial {

  self.interstitial = [[DFPInterstitial alloc]
      initWithAdUnitID:@"/6499/example/interstitial"]; // Test adUnitId. Replace
                                                       // with your targeted
                                                       // adUnitId.
  [self.interstitial setDelegate:self];

  DFPRequest *request = [DFPRequest request];
  request.testDevices = @[ kGADSimulatorID ];
  request.customTargeting = [[BVSDKManager sharedManager] getCustomTargeting];
  [self.interstitial loadRequest:request];
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
  /*
   * Note: do not show the interstitial from this callback.
   * Instead, at the appropriate time, check:
   *     [self.interstitial isReady];
   * and if true, then call:
   *     [self.interstitial presentFromRootViewController:self];
   */

  [self.interstitial presentFromRootViewController:self.rootViewController];
}

- (void)interstitial:(GADInterstitial *)ad
    didFailToReceiveAdWithError:(GADRequestError *)error {

  [[[UIAlertView alloc]
          initWithTitle:@"Error"
                message:[NSString
                            stringWithFormat:@"Failed to get ad: %@", error]
               delegate:nil
      cancelButtonTitle:@"OK"
      otherButtonTitles:nil] show];

  [[NSNotificationCenter defaultCenter]
      postNotificationName:@"INTERSTITIAL_ERROR"
                    object:nil];
}

@end
