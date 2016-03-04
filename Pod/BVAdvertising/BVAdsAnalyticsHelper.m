//
//  BVAdsAnalyticsHelper.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVCore.h"
#import "BVAdsAnalyticsHelper.h"
#import <AdSupport/AdSupport.h>
#import "BVInternalManager.h"
#include <sys/sysctl.h>
#include <sys/utsname.h>

@interface BVAdsAnalyticsHelper()

@end

@implementation BVAdsAnalyticsHelper


#pragma mark - Ad lifecycle events

-(void)adRequested:(BVAdInfo*)adInfo{
    [self queueAdLifecycleEvent:adInfo adState:@"requested" extraInfo:nil];
}

-(void)adReceived:(BVAdInfo*)adInfo {
    [self queueAdLifecycleEvent:adInfo adState:@"received" extraInfo:nil];
}

-(void)adShown:(BVAdInfo*)adInfo {
    [self queueAdLifecycleEvent:adInfo adState:@"shown" extraInfo:nil];
}

-(void)adDismissed:(BVAdInfo*)adInfo {
    [self queueAdLifecycleEvent:adInfo adState:@"dismissed" extraInfo:nil];
}

-(void)adConversion:(BVAdInfo*)adInfo {
    [self queueAdLifecycleEvent:adInfo adState:@"conversion" extraInfo:nil];
}

-(void)adFailed:(BVAdInfo*)adInfo error:(GADRequestError*)error {
    NSString* errorMessage = [NSString stringWithFormat:@"%@", error];
    [self queueAdLifecycleEvent:adInfo adState:@"failed" extraInfo:@{@"errorMessage": errorMessage}];
}

-(void)queueAdLifecycleEvent:(BVAdInfo*)adInfo adState:(NSString*)adState extraInfo:(NSDictionary*)extra {

    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    if(extra != nil){
        [eventData addEntriesFromDictionary:extra];
    }

    [eventData addEntriesFromDictionary:adInfo.customTargeting];
    
    // create with this patern, to allow for nil values
    [eventData setValue:[adInfo getFormattedAdType] forKey:@"adType"];
    [eventData setValue:adState forKey:@"adState"];
    [eventData setValue:adInfo.adUnitId forKey:@"adUnitId"];
    [eventData setValue:[NSString stringWithFormat:@"%ld", adInfo.adLoadId] forKey:@"loadId"]; //wrap in NSNumber
    [eventData setValue:@"Lifecycle" forKey:@"cl"];
    [eventData setValue:@"MobileAd" forKey:@"type"];
    [eventData setValue:@"media" forKey:@"source"];
    
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}



@end
