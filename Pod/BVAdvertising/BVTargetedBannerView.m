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

-(id)init {
    self = [super init];
    if(self) {
        [self internalSetup];
    }
    return self;
}

-(id)initWithAdSize:(GADAdSize)adSize {
    self = [super initWithAdSize:adSize];
    if(self){
        [self internalSetup];
    }
    return self;
}

-(id)initWithAdSize:(GADAdSize)adSize origin:(CGPoint)origin {
    self = [super initWithAdSize:adSize origin:origin];
    if(self){
        [self internalSetup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self internalSetup];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self internalSetup];
    }
    return self;
}

-(void)internalSetup {
    adInfo = [[BVAdInfo alloc] init];
    adInfo.adType = BVBanner;
    [[BVInternalManager sharedInstance] maybeUpdateUserProfile];
    
    delegate_interceptor = [[BVMessageInterceptor alloc] init];
    [delegate_interceptor setMiddleMan:self];
    [super setDelegate:(id)delegate_interceptor];
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
    
    [[BVInternalManager sharedInstance] adReceived:adInfo];
    
    if([self.delegate respondsToSelector:@selector(adViewDidReceiveAd:)])
    {
        [self.delegate adViewDidReceiveAd:view];
    }
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    
    [[BVInternalManager sharedInstance] adFailed:adInfo error:error];
    
    if([self.delegate respondsToSelector:@selector(adView:didFailToReceiveAdWithError:)])
    {
        [self.delegate adView:view didFailToReceiveAdWithError:error];
    }
}

/// Tells the delegate that a full screen view will be presented in response to the user clicking on
/// an ad. The delegate may want to pause animations and time sensitive interactions.
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    
    [[BVInternalManager sharedInstance] adConversion:adInfo];
    
    if([self.delegate respondsToSelector:@selector(adViewWillPresentScreen:)])
    {
        [self.delegate adViewWillPresentScreen:bannerView];
    }
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {

    if([self.delegate respondsToSelector:@selector(adViewWillDismissScreen:)])
    {
        [self.delegate adViewWillDismissScreen:bannerView];
    }
}

/// Tells the delegate that the full screen view has been dismissed. The delegate should restart
/// anything paused while handling adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {

    if([self.delegate respondsToSelector:@selector(adViewDidDismissScreen:)]) {
        [self.delegate adViewDidDismissScreen:bannerView];
    }
}

/// Tells the delegate that the user click will open another app, backgrounding the current
/// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
/// are called immediately before this method is called.
- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    
    [[BVInternalManager sharedInstance] adConversion:adInfo];
    
    if([self.delegate respondsToSelector:@selector(adViewWillLeaveApplication:)]) {
        [self.delegate adViewWillLeaveApplication:bannerView];
    }
}


@end
