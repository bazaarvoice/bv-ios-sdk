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
-(void)adDelivered:(BVAdInfo*)adInfo {
    [self.magpie adDelivered:adInfo];
}
-(void)adShown:(BVAdInfo*)adInfo {
    [self.magpie adShown:adInfo];
}
-(void)adFailed:(BVAdInfo*)adInfo error:(GADRequestError*)error {
    [self.magpie adFailed:adInfo error:error];
}

#pragma mark - Location updates

-(void)didEnterRegion:(CLCircularRegion*)region location:(BVLocationWrapper*)location {
    [self.magpie didEnterRegion:region
                       location:location];
}

-(void)didExitRegion:(CLCircularRegion*)region location:(BVLocationWrapper*)location {
    [self.magpie didExitRegion:region
                      location:location];
}

-(void)didVisit:(CLVisit*)visit location:(BVLocationWrapper*)location {
    [self.magpie didVisit:visit
                 location:location];
}

-(void)didRangeBeacon:(CLBeacon*)beacon inRegion:(CLBeaconRegion*)region location:(BVLocationWrapper*)location {
    [self.magpie didRangeBeacon:beacon
                       inRegion:region
                       location:location];
}

-(void)didUpdateLocation:(BVLocationWrapper*)location {
    [self.magpie didUpdateLocation:location];
}

#pragma mark - Gimbal-based Updates

-(void)gimbalSighting:(BVGMBLSighting*)sighting {
    [self.magpie gimbalSighting:sighting];
}

-(void)gimbalSighting:(BVGMBLSighting*)sighting forVisit:(BVGMBLVisit*)visit {
    [self.magpie gimbalSighting:sighting forVisit:visit];
}

-(void)gimbalPlaceBeginVisit:(BVGMBLVisit*)visit {
    [self.magpie gimbalPlaceBeginVisit:visit];
}

-(void)gimbalPlaceEndVisit:(BVGMBLVisit*)visit {
    [self.magpie gimbalPlaceEndVisit:visit];
}

@end
