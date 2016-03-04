//
//  BVTargetedNativeContentAdView.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVTargetedNativeContentAdView.h"
#import "BVInternalManager.h"

@implementation BVTargetedNativeContentAdView

-(void)setNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    
    [super setNativeContentAd:nativeContentAd];
    
    [[BVInternalManager sharedInstance] nativeAdShown:nativeContentAd];
    
}

@end
