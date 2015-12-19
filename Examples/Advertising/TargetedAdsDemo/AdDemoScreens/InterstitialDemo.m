//
//  InterstitialDemo.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "InterstitialDemo.h"
#import <BVSDK/BVAdvertising.h>

@interface InterstitialDemo()<GADInterstitialDelegate>

@property BVTargetedInterstitial* interstitial;
@property UIViewController* rootViewController;

@end

@implementation InterstitialDemo

-(id)initWithRootViewController:(UIViewController*)rootViewController {
    self = [super init];
    if(self){
        self.rootViewController = rootViewController;
    }
    return self;
}

-(void)requestInterstitial {
    
    self.interstitial = [[BVTargetedInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"]; //Test adUnitId. Replace with your targeted adUnitId.
    [self.interstitial setDelegate:self];
    
    BVTargetedRequest* request = [self.interstitial getTargetedRequest];

    [self.interstitial loadRequest:request];
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    /* Note: do not show the interstitial from this callback. 
      * Instead, at the appropriate time, check:
      *     [self.interstitial isReady];
      * and if true, then call:
      *     [self.interstitial presentFromRootViewController:self]; */
    
    [self.interstitial presentFromRootViewController:self.rootViewController];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[NSString stringWithFormat:@"Failed to get ad: %@", error]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"INTERSTITIAL_ERROR" object:nil];
}

@end
