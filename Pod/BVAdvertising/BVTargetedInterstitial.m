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
    
    if([self.delegate respondsToSelector:@selector(interstitialDidReceiveAd:)])
    {
        [self.delegate interstitialDidReceiveAd:ad];
    }
    [[BVInternalManager sharedInstance] adDelivered:adInfo];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    
    if([self.delegate respondsToSelector:@selector(interstitial:didFailToReceiveAdWithError:)])
    {
        [self.delegate interstitial:ad didFailToReceiveAdWithError:error];
    }
    
    [[BVInternalManager sharedInstance] adFailed:adInfo error:error];
}

#pragma mark Display-Time Lifecycle Notifications

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    
    if([self.delegate respondsToSelector:@selector(interstitialWillPresentScreen:)])
    {
        [self.delegate interstitialWillPresentScreen:ad];
    }
    [self adShown];
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    
    if([self.delegate respondsToSelector:@selector(interstitialWillDismissScreen:)])
    {
        [self.delegate interstitialWillDismissScreen:ad];
    }
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    
    if([self.delegate respondsToSelector:@selector(interstitialDidDismissScreen:)])
    {
        [self.delegate interstitialDidDismissScreen:ad];
    }
    [self adDismissed];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {

    if([self.delegate respondsToSelector:@selector(interstitialWillLeaveApplication:)])
    {
        [self.delegate interstitialWillLeaveApplication:ad];
    }
    [self adDismissed];
}

-(void)adShown {
    adInfo.adShownDateTime = [NSDate date];
}
-(void)adDismissed {
    if(adInfo.adDismissedTime == nil)
    {
        adInfo.adDismissedTime = [NSDate date];
        [[BVInternalManager sharedInstance] adShown:adInfo];
    }
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
