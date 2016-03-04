//
//  BVTargetedNativeAppInstallAdView.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVTargetedNativeAppInstallAdView.h"
#import "BVInternalManager.h"

@implementation BVTargetedNativeAppInstallAdView

-(void)setNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd {
    
    [super setNativeAppInstallAd:nativeAppInstallAd];

    [[BVInternalManager sharedInstance] nativeAdShown:nativeAppInstallAd];
    
}

@end
