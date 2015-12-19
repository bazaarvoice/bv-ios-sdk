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

@interface BVTargetedAdLoader()<GADAdLoaderDelegate, GADNativeContentAdLoaderDelegate, GADNativeAppInstallAdLoaderDelegate, GADNativeCustomTemplateAdLoaderDelegate> {
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
        adInfo = [[BVAdInfo alloc] init];
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
    
    if([delegate_interceptor.receiver respondsToSelector:@selector(adLoader:didFailToReceiveAdWithError:)])
    {
        [delegate_interceptor.receiver adLoader:adLoader didFailToReceiveAdWithError:error];
    }
    [[BVInternalManager sharedInstance] adFailed:adInfo error:error];
}

#pragma mark - GADNativeContentAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    
    if([delegate_interceptor.receiver respondsToSelector:@selector(adLoader:didReceiveNativeContentAd:)])
    {
        [delegate_interceptor.receiver performSelector:@selector(adLoader:didReceiveNativeContentAd:) withObject:adLoader withObject:nativeContentAd];
    }
    adInfo.adType = BVNativeContent;
    [[BVInternalManager sharedInstance] adDelivered:adInfo];
}

#pragma mark - GADNativeAppInstallAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd {
    
    if([delegate_interceptor.receiver respondsToSelector:@selector(adLoader:didReceiveNativeAppInstallAd:)])
    {
        [delegate_interceptor.receiver adLoader:adLoader didReceiveNativeAppInstallAd:nativeAppInstallAd];
    }
    adInfo.adType = BVNativeAppInstall;
    [[BVInternalManager sharedInstance] adDelivered:adInfo];
}

#pragma mark - GADNativeCustomTemplateAdLoaderDelegate

- (NSArray *)nativeCustomTemplateIDsForAdLoader:(GADAdLoader *)adLoader {
    
    if([delegate_interceptor.receiver respondsToSelector:@selector(nativeCustomTemplateIDsForAdLoader:)])
    {
        return [delegate_interceptor.receiver nativeCustomTemplateIDsForAdLoader:adLoader];
    }
    
    [NSException raise:@"Delegate does not conform to nativeCustomTemplateIDsForAdLoader:" format:@"BVTargetedAdLoader delegate does not conform to nativeCustomTemplateIDsForAdLoader:"];
    
    return nil;
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeCustomTemplateAd:(GADNativeCustomTemplateAd *)nativeCustomTemplateAd {
    
    if([delegate_interceptor.receiver respondsToSelector:@selector(adLoader:didReceiveNativeCustomTemplateAd:)])
    {
        return [delegate_interceptor.receiver adLoader:adLoader didReceiveNativeCustomTemplateAd:nativeCustomTemplateAd];
    }
    adInfo.adType = BVNativeCustom;
    [[BVInternalManager sharedInstance] adDelivered:adInfo];
}


@end
