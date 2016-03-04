//
//  BVInternalManager.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVSDKManager.h"
#import "BVInternalManager.h"
#import "BVAdsAnalyticsHelper.h"
#import "BVAnalyticsManager.h"

#import <AdSupport/AdSupport.h>

@interface BVInternalManager() {
    bool adTrackingEnabled;
    NSMutableDictionary* adInfoMap;
}

@property BVAdsAnalyticsHelper* magpie;

@end

@implementation BVInternalManager

+(instancetype)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

-(id)init {
    self = [super init];
    if(self){
        self.magpie = [[BVAdsAnalyticsHelper alloc] init];
        adInfoMap = [NSMutableDictionary dictionary];
        
        // Start by assuming true. If different when reading the IDFA, flop this flag and send event reporting that limit ad tracking is enabled/disabled
        adTrackingEnabled = true;
    }
    return self;
}

#pragma mark - Limit Ad Tracking

-(void)checkLimitAdTracking {
    
    bool enabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    
    if(!enabled){
        [[BVLogger sharedLogger] warning:@"Advertising tracking is not enabled -- BVAdsSDK will not provide targeted information tied to this IDFA."];
    }
    
    // disregard if no change in value
    if(adTrackingEnabled == enabled){
        return;
    }
    else if(enabled == true) {
        [[BVAnalyticsManager sharedManager] sendPersonalizationEvent:[BVSDKManager sharedManager].bvUser];
    }
    
    adTrackingEnabled = enabled;
}

#pragma mark - user

-(void)maybeUpdateUserProfile {
    [[BVSDKManager sharedManager].bvUser updateProfile:false withAPIKey:[BVSDKManager sharedManager].apiKeyShopperAdvertising isStaging:[BVSDKManager sharedManager].staging];
}

-(void)updateUserProfileForce {
    [[BVSDKManager sharedManager].bvUser updateProfile:true withAPIKey:[BVSDKManager sharedManager].apiKeyShopperAdvertising isStaging:[BVSDKManager sharedManager].staging];
}

-(void)setUserId:(NSString*)userAuthString{
    
    [BVSDKManager sharedManager].bvUser.userAuthString = userAuthString;
    
    [[BVAnalyticsManager sharedManager] sendPersonalizationEvent:[BVSDKManager sharedManager].bvUser];
    
    // try to grab the profile as soon as its available
    [self updateUserProfileForce];
    [self performSelector:@selector(updateUserProfileForce) withObject:nil afterDelay:5.0];
    [self performSelector:@selector(updateUserProfileForce) withObject:nil afterDelay:12.0];
    [self performSelector:@selector(updateUserProfileForce) withObject:nil afterDelay:24.0];
}


#pragma mark - Ad lifecycle updates

-(void)adRequested:(BVAdInfo*)adInfo {
    [self.magpie adRequested:adInfo];
}

-(void)adReceived:(BVAdInfo*)adInfo { //
    [self.magpie adReceived:adInfo];
}

-(void)adDismissed:(BVAdInfo*)adInfo {
    [self.magpie adDismissed:adInfo];
}

-(void)adConversion:(BVAdInfo *)adInfo {
    [self.magpie adConversion:adInfo];
}

-(void)adShown:(BVAdInfo*)adInfo {
    [self.magpie adShown:adInfo];
}

-(void)adFailed:(BVAdInfo*)adInfo error:(GADRequestError*)error {
    [self.magpie adFailed:adInfo error:error];
}

-(void)nativeAdShown:(GADNativeAd*)nativeAd {
    BVAdInfo* adInfo = [self getAdInfoForNativeAd:nativeAd];
    [self adShown:adInfo];
}

-(void)nativeAdConversion:(GADNativeAd*)nativeAd {
    
    BVAdInfo* adInfo = [self getAdInfoForNativeAd:nativeAd];
    [self adConversion:adInfo];
    
}

-(void)trackNativeAd:(GADNativeAd*)nativeAd withAdLoaderInfo:(BVAdInfo*)adLoaderInfo {
    
    BVAdType bvAdType = [self adTypeOfNativeAd:nativeAd];
    
    BVAdInfo* info = [[BVAdInfo alloc] initWithAdUnitId:adLoaderInfo.adUnitId adType:bvAdType];
    info.customTargeting = adLoaderInfo.customTargeting;

    [adInfoMap setObject:info forKey:[NSValue valueWithNonretainedObject:nativeAd]];
}

-(BVAdInfo*)getAdInfoForNativeAd:(GADNativeAd*)nativeAd {
    
    return [adInfoMap objectForKey:[NSValue valueWithNonretainedObject:nativeAd]];
    
}

-(BVAdType)adTypeOfNativeAd:(GADNativeAd*)nativeAd {
    if([nativeAd isKindOfClass:[GADNativeContentAd class]]) {
        return BVNativeContent;
    }
    else if([nativeAd isKindOfClass:[GADNativeCustomTemplateAd class]]) {
        return BVNativeCustom;
    }
    else {
        return BVNativeAppInstall;
    }
}


@end
