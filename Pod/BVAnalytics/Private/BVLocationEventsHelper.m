//
//  BVAdsSDK.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVLocationEventsHelper.h"
#import "BVLocationWrapper.h"
#import "BVAnalyticsManager.h"

@implementation BVLocationEventsHelper

+(void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLCircularRegion *)region contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    

    BVLocationWrapper* locationWrapper = [[BVLocationWrapper alloc] init];
    locationWrapper.contextualTier1 = tier1;
    locationWrapper.contextualTier2 = tier2;
    locationWrapper.location = [manager location];
    
    [BVLocationEventsHelper didEnterRegion:region location:locationWrapper];
}

+(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLCircularRegion *)region contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVLocationWrapper* locationWrapper = [[BVLocationWrapper alloc] init];
    locationWrapper.contextualTier1 = tier1;
    locationWrapper.contextualTier2 = tier2;
    locationWrapper.location = [manager location];
    
    [BVLocationEventsHelper didExitRegion:region location:locationWrapper];
}

+(void)locationManager:(CLLocationManager*)manager didVisit:(CLVisit *)visit contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVLocationWrapper* locationWrapper = [[BVLocationWrapper alloc] init];
    locationWrapper.contextualTier1 = tier1;
    locationWrapper.contextualTier2 = tier2;
    locationWrapper.location = [manager location];
    
    [BVLocationEventsHelper didVisit:visit location:locationWrapper];
}

+(void)locationManager:(CLLocationManager*)manager didRangeBeacon:(CLBeacon*)beacon inRegion:(CLBeaconRegion*)region contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVLocationWrapper* locationWrapper = [[BVLocationWrapper alloc] init];
    locationWrapper.contextualTier1 = tier1;
    locationWrapper.contextualTier2 = tier2;
    locationWrapper.location = [manager location];
    
    [BVLocationEventsHelper didRangeBeacon:beacon inRegion:region location:locationWrapper];
}

+(void)locationManager:(CLLocationManager*)manager didUpdateLocation:(CLLocation*)location contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVLocationWrapper* locationWrapper = [[BVLocationWrapper alloc] init];
    locationWrapper.contextualTier1 = tier1;
    locationWrapper.contextualTier2 = tier2;
    locationWrapper.location = [manager location];
    
    [BVLocationEventsHelper didUpdateLocation:locationWrapper];
}

+(void)gimbalBeaconSighting:(NSInteger)RSSI date:(NSDate*)date identifier:(NSString*)identifier name:(NSString*)name contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVGMBLSighting* sighting = [[BVGMBLSighting alloc] init];
    sighting.RSSI = RSSI;
    sighting.date = date;
    sighting.identifier = identifier;
    sighting.name = name;
    
    [BVLocationEventsHelper gimbalSighting:sighting];
}

+(void)gimbalPlaceBeginVisit:(NSDate*)arrivalDate dwellTime:(NSTimeInterval)dwellTime departureDate:(NSDate*)departureDate identifier:(NSString*)identifier name:(NSString*)name contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVGMBLVisit* visit = [[BVGMBLVisit alloc] init];
    visit.arrivalDate = arrivalDate;
    visit.dwellTime = dwellTime;
    visit.departureDate = departureDate;
    visit.identifier = identifier;
    visit.name = name;
    
    [BVLocationEventsHelper gimbalPlaceBeginVisit:visit];
}

+(void)gimbalPlaceEndVisit:(NSDate*)arrivalDate dwellTime:(NSTimeInterval)dwellTime departureDate:(NSDate*)departureDate identifier:(NSString*)identifier name:(NSString*)name contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVGMBLVisit* visit = [[BVGMBLVisit alloc] init];
    visit.arrivalDate = arrivalDate;
    visit.dwellTime = dwellTime;
    visit.departureDate = departureDate;
    visit.identifier = identifier;
    visit.name = name;

    [BVLocationEventsHelper gimbalPlaceEndVisit:visit];
}

+(void)gimbalBeaconSightingForVisits:(NSInteger)RSSI date:(NSDate*)date beaconIdentifier:(NSString*)beaconIdentifier beaconName:(NSString*)beaconName arrivalDate:(NSDate*)arrivalDate dwellTime:(NSTimeInterval)dwellTime departureDate:(NSDate*)departureDate visitIdentifier:(NSString*)visitIdentifier visitName:(NSString*)visitName contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVGMBLVisit* visit = [[BVGMBLVisit alloc] init];
    visit.arrivalDate = arrivalDate;
    visit.dwellTime = dwellTime;
    visit.departureDate = departureDate;
    visit.identifier = visitIdentifier;
    visit.name = visitName;
    
    BVGMBLSighting* sighting = [[BVGMBLSighting alloc] init];
    sighting.RSSI = RSSI;
    sighting.date = date;
    sighting.identifier = beaconIdentifier;
    sighting.name = beaconName;
    
    BVLocationWrapper* locationWrapper = [[BVLocationWrapper alloc] init];
    locationWrapper.contextualTier1 = tier1;
    locationWrapper.contextualTier2 = tier2;
    
    [BVLocationEventsHelper gimbalSighting:sighting forVisit:visit];
}


#pragma mark - Gimbal updates

+(NSDictionary*)dictForVisit:(BVGMBLVisit*)visit {
    
    // create with this patern, to allow for nil values
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:[[BVAnalyticsManager sharedManager] formatDate:visit.arrivalDate] forKey:@"arrivalDate"];
    [params setValue:[[BVAnalyticsManager sharedManager] formatDate:visit.departureDate] forKey:@"departureDate"];
    [params setValue:@(visit.dwellTime) forKey:@"dwellTime"]; // wrap in NSNumber
    [params setValue:visit.identifier forKey:@"identifier"];
    [params setValue:visit.name forKey:@"name"];
    return params;
}

+(NSDictionary*)dictForSighting:(BVGMBLSighting*)sighting {
    
    // create with this patern, to allow for nil values
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@(sighting.RSSI) forKey:@"RSSI"]; // wrap in NSNumber
    [params setValue:[[BVAnalyticsManager sharedManager] formatDate:sighting.date] forKey:@"date"];
    [params setValue:sighting.identifier forKey:@"identifier"];
    [params setValue:sighting.name forKey:@"name"];
    return params;
}

+(void)gimbalSighting:(BVGMBLSighting*)sighting {
    
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[self dictForSighting:sighting]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"GimbalSighting",
                                          @"source": @"location-mobile"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}


+(void)gimbalSighting:(BVGMBLSighting*)sighting forVisit:(BVGMBLVisit*)visit {
    
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[self dictForVisit:visit]];
    [eventData addEntriesFromDictionary:[self dictForSighting:sighting]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"GimbalSighting",
                                          @"source": @"location-mobile"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}

+(void)gimbalPlaceBeginVisit:(BVGMBLVisit*)visit {
    [self gimbalPlaceVisit:[self dictForVisit:visit] isBegin:true];
}

+(void)gimbalPlaceEndVisit:(BVGMBLVisit*)visit {
    [self gimbalPlaceVisit:[self dictForVisit:visit] isBegin:false];
}

+(void)gimbalPlaceVisit:(NSDictionary*)visitParams isBegin:(bool)begin {
    
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:visitParams];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"GimbalVisit",
                                          @"source": @"location-mobile",
                                          @"begin": [NSNumber numberWithBool:begin],
                                          @"end": [NSNumber numberWithBool:!begin]
                                          }];
    
    // send request
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}


#pragma mark - Location updates

+(NSDictionary*)getLocationParams:(BVLocationWrapper*)location {
    
    // create with this patern, to allow for nil values
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@(location.location.coordinate.latitude) forKey:@"lat"];
    [params setValue:@(location.location.coordinate.longitude) forKey:@"long"];
    [params setValue:@(location.location.horizontalAccuracy) forKey:@"accuracy"];
    [params setValue:location.contextualTier1 forKey:@"tier1"];
    [params setValue:location.contextualTier2 forKey:@"tier2"];
    
    return params;
}

+(NSDictionary*)getGeofenceParams:(CLCircularRegion*)region {
    
    // create with this patern, to allow for nil values
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@(region.center.latitude) forKey:@"centerLat"];
    [params setValue:@(region.center.longitude) forKey:@"centerLong"];
    [params setValue:@(region.radius) forKey:@"radius"];
    
    return params;
}

+(NSDictionary*)getVisitParams:(CLVisit*)visit {
    
    // create with this patern, to allow for nil values
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@(visit.coordinate.latitude) forKey:@"centerLat"];
    [params setValue:@(visit.coordinate.longitude) forKey:@"centerLong"];
    [params setValue:@(visit.horizontalAccuracy) forKey:@"radius"];
    
    return params;
}

+(NSDictionary*)getBeaconParams:(CLBeacon*)beacon forRegion:(CLRegion*)region {
    
    // create with this patern, to allow for nil values
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:beacon.proximityUUID.UUIDString forKey:@"beaconUUID"];
    [params setValue:beacon.major forKey:@"beaconMajor"];
    [params setValue:beacon.minor forKey:@"beaconMinor"];
    [params setValue:@(beacon.rssi) forKey:@"beaconRSSI"];
    [params setValue:region.identifier forKey:@"beaconId"];
    
    return params;
}

+(void)didEnterRegion:(CLCircularRegion*)region location:(BVLocationWrapper*)location {
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[self getLocationParams:location]];
    [eventData addEntriesFromDictionary:[self getGeofenceParams:region]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"Geofence",
                                          @"source": @"location-mobile",
                                          @"updateType": @"Enter"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}

+(void)didExitRegion:(CLCircularRegion*)region location:(BVLocationWrapper*)location {
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[self getLocationParams:location]];
    [eventData addEntriesFromDictionary:[self getGeofenceParams:region]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"Geofence",
                                          @"source": @"location-mobile",
                                          @"updateType": @"Exit"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}

+(void)didVisit:(CLVisit*)visit location:(BVLocationWrapper*)location {
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[self getLocationParams:location]];
    [eventData addEntriesFromDictionary:[self getVisitParams:visit]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"Geofence",
                                          @"source": @"location-mobile",
                                          @"updateType": @"Enter"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}

+(void)didRangeBeacon:(CLBeacon*)beacon inRegion:(CLBeaconRegion*)region location:(BVLocationWrapper*)location {
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[self getLocationParams:location]];
    [eventData addEntriesFromDictionary:[self getBeaconParams:beacon forRegion:region]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"Beacon",
                                          @"source": @"location-mobile"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}

+(void)didUpdateLocation:(BVLocationWrapper*)location {
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    [eventData addEntriesFromDictionary:[self getLocationParams:location]];
    [eventData addEntriesFromDictionary:@{
                                          @"cl": @"Location",
                                          @"type": @"Geo",
                                          @"source": @"location-mobile"
                                          }];
    [[BVAnalyticsManager sharedManager] queueEvent:eventData];
}



@end
