//
//  BVAdsSDK.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVLocationEventsHelper.h"
#import "BVInternalManager.h"
#import "BVLocationWrapper.h"
#import "BVAnalyticsManager.h"

@implementation BVLocationEventsHelper

+(void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLCircularRegion *)region contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    

    BVLocationWrapper* locationWrapper = [[BVLocationWrapper alloc] init];
    locationWrapper.contextualTier1 = tier1;
    locationWrapper.contextualTier2 = tier2;
    locationWrapper.location = [manager location];
    
    [[BVInternalManager sharedInstance] didEnterRegion:region location:locationWrapper];
}

+(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLCircularRegion *)region contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVLocationWrapper* locationWrapper = [[BVLocationWrapper alloc] init];
    locationWrapper.contextualTier1 = tier1;
    locationWrapper.contextualTier2 = tier2;
    locationWrapper.location = [manager location];
    
    [[BVInternalManager sharedInstance] didExitRegion:region location:locationWrapper];
}

+(void)locationManager:(CLLocationManager*)manager didVisit:(CLVisit *)visit contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVLocationWrapper* locationWrapper = [[BVLocationWrapper alloc] init];
    locationWrapper.contextualTier1 = tier1;
    locationWrapper.contextualTier2 = tier2;
    locationWrapper.location = [manager location];
    
    [[BVInternalManager sharedInstance] didVisit:visit location:locationWrapper];
}

+(void)locationManager:(CLLocationManager*)manager didRangeBeacon:(CLBeacon*)beacon inRegion:(CLBeaconRegion*)region contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVLocationWrapper* locationWrapper = [[BVLocationWrapper alloc] init];
    locationWrapper.contextualTier1 = tier1;
    locationWrapper.contextualTier2 = tier2;
    locationWrapper.location = [manager location];
    
    [[BVInternalManager sharedInstance] didRangeBeacon:beacon inRegion:region location:locationWrapper];
}

+(void)locationManager:(CLLocationManager*)manager didUpdateLocation:(CLLocation*)location contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVLocationWrapper* locationWrapper = [[BVLocationWrapper alloc] init];
    locationWrapper.contextualTier1 = tier1;
    locationWrapper.contextualTier2 = tier2;
    locationWrapper.location = [manager location];
    
    [[BVInternalManager sharedInstance] didUpdateLocation:locationWrapper];
}

+(void)gimbalBeaconSighting:(NSInteger)RSSI date:(NSDate*)date identifier:(NSString*)identifier name:(NSString*)name contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVGMBLSighting* sighting = [[BVGMBLSighting alloc] init];
    sighting.RSSI = RSSI;
    sighting.date = date;
    sighting.identifier = identifier;
    sighting.name = name;
    
    [[BVInternalManager sharedInstance] gimbalSighting:sighting];
}

+(void)gimbalPlaceBeginVisit:(NSDate*)arrivalDate dwellTime:(NSTimeInterval)dwellTime departureDate:(NSDate*)departureDate identifier:(NSString*)identifier name:(NSString*)name contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVGMBLVisit* visit = [[BVGMBLVisit alloc] init];
    visit.arrivalDate = arrivalDate;
    visit.dwellTime = dwellTime;
    visit.departureDate = departureDate;
    visit.identifier = identifier;
    visit.name = name;
    
    [[BVInternalManager sharedInstance] gimbalPlaceBeginVisit:visit];
}

+(void)gimbalPlaceEndVisit:(NSDate*)arrivalDate dwellTime:(NSTimeInterval)dwellTime departureDate:(NSDate*)departureDate identifier:(NSString*)identifier name:(NSString*)name contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2 {
    
    BVGMBLVisit* visit = [[BVGMBLVisit alloc] init];
    visit.arrivalDate = arrivalDate;
    visit.dwellTime = dwellTime;
    visit.departureDate = departureDate;
    visit.identifier = identifier;
    visit.name = name;

    [[BVInternalManager sharedInstance] gimbalPlaceEndVisit:visit];
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
    
    [[BVInternalManager sharedInstance] gimbalSighting:sighting forVisit:visit];
}

@end
