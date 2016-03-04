//
//  BVMessageInterceptor.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVMessageInterceptor.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BVMessageInterceptor()<GADNativeContentAdLoaderDelegate, GADNativeAppInstallAdLoaderDelegate, GADNativeCustomTemplateAdLoaderDelegate>

@end

@implementation BVMessageInterceptor

@synthesize receiver;
@synthesize middleMan;

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([middleMan respondsToSelector:aSelector]) { return middleMan; }
    if ([receiver respondsToSelector:aSelector]) { return receiver; }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([middleMan respondsToSelector:aSelector]) { return YES; }
    if ([receiver respondsToSelector:aSelector]) { return YES; }
    return [super respondsToSelector:aSelector];
}

/// Conform to GADAdLoader delegates, to avoid warnings.
/// BVMessageInterceptor passes these messages along without hitting these method,
///     if delegate conforms properly.

-(void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    [NSException raise:@"Invalid delegate." format:@"Delegate does not conform to `adLoader:didFailToReceiveAdWithError:`"];
}

-(void)adLoader:(GADAdLoader *)adLoader didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    [NSException raise:@"Invalid delegate." format:@"Delegate does not conform to `adLoader:didReceiveNativeContentAd:`"];
}

-(void)adLoader:(GADAdLoader *)adLoader didReceiveNativeCustomTemplateAd:(GADNativeCustomTemplateAd *)nativeCustomTemplateAd {
    [NSException raise:@"Invalid delegate." format:@"Delegate does not conform to `adLoader:didReceiveNativeCustomTemplateAd:`"];
}

-(NSArray*)nativeCustomTemplateIDsForAdLoader:(GADAdLoader *)adLoader {
    
    [NSException raise:@"Invalid delegate." format:@"Delegate does not conform to `nativeCustomTemplateIDsForAdLoader:`"];
    return nil;
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd {
    [NSException raise:@"Invalid delegate." format:@"Delegate does not conform to `didReceiveNativeAppInstallAd:`"];
}

@end