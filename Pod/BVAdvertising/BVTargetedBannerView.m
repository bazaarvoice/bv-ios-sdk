//
//  BVTargetedBannerView.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVTargetedBannerView.h"
#import "BVInternalManager.h"
#import "BVSDKManager.h"
#import "BVMessageInterceptor.h"
#import "BVTargetedRequest.h"

@interface BVTargetedBannerView(){
    BVMessageInterceptor* delegate_interceptor;
    BVAdInfo* adInfo;
}
@end

@implementation BVTargetedBannerView

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

- (id)delegate {
    return delegate_interceptor.receiver;
}

- (void)setDelegate:(id)newDelegate {
    [super setDelegate:nil];
    [delegate_interceptor setReceiver:newDelegate];
    [super setDelegate:(id)delegate_interceptor];
}

-(id)initWithAdSize:(GADAdSize)adSize {
    self = [super initWithAdSize:adSize];
    if(self){
        adInfo = [[BVAdInfo alloc] init];
        adInfo.adType = BVBanner;
        [[BVInternalManager sharedInstance] maybeUpdateUserProfile];
        
        delegate_interceptor = [[BVMessageInterceptor alloc] init];
        [delegate_interceptor setMiddleMan:self];
        [super setDelegate:(id)delegate_interceptor];
    }
    return self;
}

-(void)setAdUnitID:(NSString *)adUnitID {
    [super setAdUnitID:adUnitID];
    adInfo.adUnitId = adUnitID;
}

- (void)dealloc {
    delegate_interceptor = nil;
}

#pragma mark - GADBannerViewDelegate intercepting

- (void)adViewDidReceiveAd:(GADBannerView *)view {
    if([self.delegate respondsToSelector:@selector(adViewDidReceiveAd:)])
    {
        [self.delegate adViewDidReceiveAd:view];
    }
    [[BVInternalManager sharedInstance] adDelivered:adInfo];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    if([self.delegate respondsToSelector:@selector(adView:didFailToReceiveAdWithError:)])
    {
        [self.delegate adView:view didFailToReceiveAdWithError:error];
    }
    [[BVInternalManager sharedInstance] adFailed:adInfo error:error];
}

@end
