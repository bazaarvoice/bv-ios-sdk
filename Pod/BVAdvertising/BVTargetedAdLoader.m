//
//  BVTargetedAdLoader.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVTargetedAdLoader.h"
#import "BVInternalManager.h"
#import "BVMessageInterceptor.h"
#import "BVSDKManager.h"

@interface BVTargetedAdLoader()<GADAdLoaderDelegate, GADNativeContentAdLoaderDelegate, GADNativeAppInstallAdLoaderDelegate, GADNativeCustomTemplateAdLoaderDelegate, GADNativeAdDelegate> {
    BVMessageInterceptor* delegate_interceptor;
    BVAdInfo* adInfo;
}

@end

@implementation BVTargetedAdLoader

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
    return delegate_interceptor.middleMan;
}

- (void)setDelegate:(id)newDelegate {
    [super setDelegate:nil];
    [delegate_interceptor setReceiver:newDelegate];
    [super setDelegate:(id)delegate_interceptor];
}

-(id)initWithAdUnitID:(NSString *)adUnitID rootViewController:(UIViewController *)rootViewController adTypes:(NSArray *)adTypes options:(NSArray *)options {
    
    self = [super initWithAdUnitID:adUnitID rootViewController:rootViewController adTypes:adTypes options:options];
    if(self){
        
        adInfo = [[BVAdInfo alloc] initWithAdUnitId:adUnitID adType:BVNativeContent];
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

#pragma mark - GADAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    
    [[BVInternalManager sharedInstance] adFailed:adInfo error:error];
    
    [delegate_interceptor.receiver adLoader:adLoader didFailToReceiveAdWithError:error];

}

#pragma mark - GADNativeContentAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    
    [adInfo setAdType:BVNativeContent];
    [[BVInternalManager sharedInstance] adReceived:adInfo];
    
    [[BVInternalManager sharedInstance] trackNativeAd:nativeContentAd withAdLoaderInfo:adInfo];
    
    nativeContentAd.delegate = self;
    
    [delegate_interceptor.receiver performSelector:@selector(adLoader:didReceiveNativeContentAd:) withObject:adLoader withObject:nativeContentAd];
    
}

#pragma mark - GADNativeAppInstallAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd {
    
    [adInfo setAdType:BVNativeAppInstall];
    [[BVInternalManager sharedInstance] adReceived:adInfo];
    
    [[BVInternalManager sharedInstance] trackNativeAd:nativeAppInstallAd withAdLoaderInfo:adInfo];
    
    nativeAppInstallAd.delegate = self;
    
    [delegate_interceptor.receiver adLoader:adLoader didReceiveNativeAppInstallAd:nativeAppInstallAd];

}

#pragma mark - GADNativeCustomTemplateAdLoaderDelegate

- (NSArray *)nativeCustomTemplateIDsForAdLoader:(GADAdLoader *)adLoader {
    
    return [delegate_interceptor.receiver nativeCustomTemplateIDsForAdLoader:adLoader];
    
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeCustomTemplateAd:(GADNativeCustomTemplateAd *)nativeCustomTemplateAd {
    
    [adInfo setAdType:BVNativeCustom];
    [[BVInternalManager sharedInstance] adReceived:adInfo];
    
    [[BVInternalManager sharedInstance] trackNativeAd:nativeCustomTemplateAd withAdLoaderInfo:adInfo];
    
    nativeCustomTemplateAd.delegate = self;
    
    return [delegate_interceptor.receiver adLoader:adLoader didReceiveNativeCustomTemplateAd:nativeCustomTemplateAd];
    
}

#pragma mark GADNativeAdDelegate 

- (void)nativeAdWillPresentScreen:(GADNativeAd *)nativeAd {

    [[BVInternalManager sharedInstance] nativeAdConversion:nativeAd];
    
}

- (void)nativeAdWillLeaveApplication:(GADNativeAd *)nativeAd {
    
    [[BVInternalManager sharedInstance] nativeAdConversion:nativeAd];
    
}



@end
