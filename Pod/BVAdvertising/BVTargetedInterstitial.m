//
//  BVTargettedInterstitial.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVTargetedInterstitial.h"
#import "BVInternalManager.h"
#import "BVSDKManager.h"
#import "BVMessageInterceptor.h"
#import "BVTargetedRequest.h"

@interface BVTargetedInterstitial(){
    BVMessageInterceptor* delegate_interceptor;
    BVAdInfo* adInfo;
}

@end


@implementation BVTargetedInterstitial

-(BVTargetedRequest*)getTargetedRequest {
    adInfo.customTargeting = [[BVSDKManager sharedManager].bvUser getTargetingKeywords];
    
    BVTargetedRequest* targetedRequest = [BVTargetedRequest request];
    targetedRequest.customTargeting = adInfo.customTargeting;
    return targetedRequest;
}

-(void)loadRequest:(GADRequest *)request {
    [super loadRequest:request];
    [[BVInternalManager sharedInstance] adRequested:adInfo];
}


#pragma mark Ad Request Lifecycle Notifications

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    
    [[BVInternalManager sharedInstance] adReceived:adInfo];
    
    if([self.delegate respondsToSelector:@selector(interstitialDidReceiveAd:)])
    {
        [self.delegate interstitialDidReceiveAd:ad];
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    
    [[BVInternalManager sharedInstance] adFailed:adInfo error:error];
    
    if([self.delegate respondsToSelector:@selector(interstitial:didFailToReceiveAdWithError:)])
    {
        [self.delegate interstitial:ad didFailToReceiveAdWithError:error];
    }
}

#pragma mark Display-Time Lifecycle Notifications

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    
    [self adShown];
    
    if([self.delegate respondsToSelector:@selector(interstitialWillPresentScreen:)])
    {
        [self.delegate interstitialWillPresentScreen:ad];
    }
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    
    if([self.delegate respondsToSelector:@selector(interstitialWillDismissScreen:)])
    {
        [self.delegate interstitialWillDismissScreen:ad];
    }
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    
    [self adDismissed];
    
    if([self.delegate respondsToSelector:@selector(interstitialDidDismissScreen:)])
    {
        [self.delegate interstitialDidDismissScreen:ad];
    }
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {

    [self adConversion];
    
    if([self.delegate respondsToSelector:@selector(interstitialWillLeaveApplication:)])
    {
        [self.delegate interstitialWillLeaveApplication:ad];
    }
}

-(void)adShown {
    
    [[BVInternalManager sharedInstance] adShown:adInfo];
    
}

-(void)adConversion {
    
    [[BVInternalManager sharedInstance] adConversion:adInfo];
    
}

-(void)adDismissed {

    [[BVInternalManager sharedInstance] adDismissed:adInfo];
    
}

- (id)delegate {
    return delegate_interceptor.receiver;
}

- (void)setDelegate:(id)newDelegate {
    [super setDelegate:nil];
    [delegate_interceptor setReceiver:newDelegate];
    [super setDelegate:(id)delegate_interceptor];
}

- (id)initWithAdUnitID:(NSString *)adUnitID {
    self = [super initWithAdUnitID:adUnitID];
    if(self){
        adInfo = [[BVAdInfo alloc] initWithAdUnitId:adUnitID adType:BVInterstitial];
        [[BVInternalManager sharedInstance] maybeUpdateUserProfile];
        
        delegate_interceptor = [[BVMessageInterceptor alloc] init];
        [delegate_interceptor setMiddleMan:self];
        [super setDelegate:(id)delegate_interceptor];
    }
    return self;
}

- (void)dealloc {
    delegate_interceptor = nil;
}

@end
