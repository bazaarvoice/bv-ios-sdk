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

-(void)sendLimitAdTrackingEvent:(bool)enabled {
    NSMutableDictionary* eventData = [NSMutableDictionary dictionaryWithDictionary:[[BVAnalyticsManager sharedManager]  getMobileDiagnosticParams]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl":@"Mobile",
                                          @"type": @"LimitAdTracking"
                                          }];
    
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}


#pragma mark - Ad lifecycle events

-(void)adRequested:(BVAdInfo*)adInfo{
    [self queueAdLifecycleEvent:adInfo adState:@"requested" extraInfo:nil];
}

-(void)adDelivered:(BVAdInfo*)adInfo {
    [self queueAdLifecycleEvent:adInfo adState:@"delivered" extraInfo:nil];
}

-(void)adShown:(BVAdInfo*)adInfo {
    [self queueAdLifecycleEvent:adInfo adState:@"shown" extraInfo:nil];
}

-(void)adFailed:(BVAdInfo*)adInfo error:(GADRequestError*)error {
    NSString* errorMessage = [NSString stringWithFormat:@"%@", error];
    [self queueAdLifecycleEvent:adInfo adState:@"failed" extraInfo:@{@"errorMessage": errorMessage}];
}

-(void)queueAdLifecycleEvent:(BVAdInfo*)adInfo adState:(NSString*)adState extraInfo:(NSDictionary*)extra {

    NSNumber* visibleDuration = [self getTimeInterval:adInfo];
    
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    if(extra != nil){
        [eventData addEntriesFromDictionary:extra];
    }
    [eventData addEntriesFromDictionary:[[BVAnalyticsManager sharedManager] getMobileDiagnosticParams]];
    [eventData addEntriesFromDictionary:adInfo.customTargeting];
    
    // create with this patern, to allow for nil values
    [eventData setValue:[adInfo getFormattedAdType] forKey:@"adType"];
    [eventData setValue:visibleDuration forKey:@"visibleDuration"];
    [eventData setValue:adState forKey:@"adState"];
    [eventData setValue:adInfo.adUnitId forKey:@"adUnitId"];
    [eventData setValue:@(adInfo.adLoadId) forKey:@"loadId"]; //wrap in NSNumber
    [eventData setValue:@"Lifecycle" forKey:@"cl"];
    [eventData setValue:@"MobileAd" forKey:@"type"];
    
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}

-(NSNumber*)getTimeInterval:(BVAdInfo*)adInfo {

    if(adInfo.adShownDateTime != nil && adInfo.adDismissedTime != nil){
        return @([adInfo.adDismissedTime timeIntervalSinceDate:adInfo.adShownDateTime]);
    }
    
    return nil;
}


#pragma mark - Gimbal updates

-(NSDictionary*)dictForVisit:(BVGMBLVisit*)visit {
    
    // create with this patern, to allow for nil values
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:[[BVAnalyticsManager sharedManager] formatDate:visit.arrivalDate] forKey:@"arrivalDate"];
    [params setValue:[[BVAnalyticsManager sharedManager] formatDate:visit.departureDate] forKey:@"departureDate"];
    [params setValue:@(visit.dwellTime) forKey:@"dwellTime"]; // wrap in NSNumber
    [params setValue:visit.identifier forKey:@"identifier"];
    [params setValue:visit.name forKey:@"name"];
    return params;
}

-(NSDictionary*)dictForSighting:(BVGMBLSighting*)sighting {
    
    // create with this patern, to allow for nil values
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@(sighting.RSSI) forKey:@"RSSI"]; // wrap in NSNumber
    [params setValue:[[BVAnalyticsManager sharedManager] formatDate:sighting.date] forKey:@"date"];
    [params setValue:sighting.identifier forKey:@"identifier"];
    [params setValue:sighting.name forKey:@"name"];
    return params;
}

-(void)gimbalSighting:(BVGMBLSighting*)sighting {
    
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[[BVAnalyticsManager sharedManager] getMobileDiagnosticParams]];
    [eventData addEntriesFromDictionary:[self dictForSighting:sighting]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"GimbalSighting"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}


-(void)gimbalSighting:(BVGMBLSighting*)sighting forVisit:(BVGMBLVisit*)visit {
    
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[[BVAnalyticsManager sharedManager] getMobileDiagnosticParams]];
    [eventData addEntriesFromDictionary:[self dictForVisit:visit]];
    [eventData addEntriesFromDictionary:[self dictForSighting:sighting]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"GimbalSighting"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}

-(void)gimbalPlaceBeginVisit:(BVGMBLVisit*)visit {
    [self gimbalPlaceVisit:[self dictForVisit:visit] isBegin:true];
}

-(void)gimbalPlaceEndVisit:(BVGMBLVisit*)visit {
    [self gimbalPlaceVisit:[self dictForVisit:visit] isBegin:false];
}

-(void)gimbalPlaceVisit:(NSDictionary*)visitParams isBegin:(bool)begin {
    
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[[BVAnalyticsManager sharedManager] getMobileDiagnosticParams]];
    [eventData addEntriesFromDictionary:visitParams];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"GimbalVisit",
                                          @"begin": [NSNumber numberWithBool:begin],
                                          @"end": [NSNumber numberWithBool:!begin]
                                          }];
    
    // send request
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}


#pragma mark - Location updates

-(NSDictionary*)getLocationParams:(BVLocationWrapper*)location {
    
    // create with this patern, to allow for nil values
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@(location.location.coordinate.latitude) forKey:@"lat"];
    [params setValue:@(location.location.coordinate.longitude) forKey:@"long"];
    [params setValue:@(location.location.horizontalAccuracy) forKey:@"accuracy"];
    [params setValue:location.contextualTier1 forKey:@"tier1"];
    [params setValue:location.contextualTier2 forKey:@"tier2"];
    
    return params;
}

-(NSDictionary*)getGeofenceParams:(CLCircularRegion*)region {
    
    // create with this patern, to allow for nil values
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@(region.center.latitude) forKey:@"centerLat"];
    [params setValue:@(region.center.longitude) forKey:@"centerLong"];
    [params setValue:@(region.radius) forKey:@"radius"];
    
    return params;
}

-(NSDictionary*)getVisitParams:(CLVisit*)visit {
    
    // create with this patern, to allow for nil values
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@(visit.coordinate.latitude) forKey:@"centerLat"];
    [params setValue:@(visit.coordinate.longitude) forKey:@"centerLong"];
    [params setValue:@(visit.horizontalAccuracy) forKey:@"radius"];
    
    return params;
}

-(NSDictionary*)getBeaconParams:(CLBeacon*)beacon forRegion:(CLRegion*)region {
    
    // create with this patern, to allow for nil values
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:beacon.proximityUUID.UUIDString forKey:@"beaconUUID"];
    [params setValue:beacon.major forKey:@"beaconMajor"];
    [params setValue:beacon.minor forKey:@"beaconMinor"];
    [params setValue:@(beacon.rssi) forKey:@"beaconRSSI"];
    [params setValue:region.identifier forKey:@"beaconId"];
    
    return params;
}

-(void)didEnterRegion:(CLCircularRegion*)region location:(BVLocationWrapper*)location {
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[[BVAnalyticsManager sharedManager] getMobileDiagnosticParams]];
    [eventData addEntriesFromDictionary:[self getLocationParams:location]];
    [eventData addEntriesFromDictionary:[self getGeofenceParams:region]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"Geofence",
                                          @"updateType": @"Enter"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}

-(void)didExitRegion:(CLCircularRegion*)region location:(BVLocationWrapper*)location {
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[[BVAnalyticsManager sharedManager] getMobileDiagnosticParams]];
    [eventData addEntriesFromDictionary:[self getLocationParams:location]];
    [eventData addEntriesFromDictionary:[self getGeofenceParams:region]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"Geofence",
                                          @"updateType": @"Exit"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}

-(void)didVisit:(CLVisit*)visit location:(BVLocationWrapper*)location {
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[[BVAnalyticsManager sharedManager] getMobileDiagnosticParams]];
    [eventData addEntriesFromDictionary:[self getLocationParams:location]];
    [eventData addEntriesFromDictionary:[self getVisitParams:visit]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"Geofence",
                                          @"updateType": @"Enter"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}

-(void)didRangeBeacon:(CLBeacon*)beacon inRegion:(CLBeaconRegion*)region location:(BVLocationWrapper*)location {
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[[BVAnalyticsManager sharedManager] getMobileDiagnosticParams]];
    [eventData addEntriesFromDictionary:[self getLocationParams:location]];
    [eventData addEntriesFromDictionary:[self getBeaconParams:beacon forRegion:region]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"Beacon"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}

-(void)didUpdateLocation:(BVLocationWrapper*)location {
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[[BVAnalyticsManager sharedManager] getMobileDiagnosticParams]];
    [eventData addEntriesFromDictionary:[self getLocationParams:location]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"Geo"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}


@end
