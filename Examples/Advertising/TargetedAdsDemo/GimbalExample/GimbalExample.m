//
//  GimbalListener.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

/*
#import "GimbalExample.h"
#import <Gimbal/Gimbal.h>
#import <BVAdsSDK/BVAdsSDK.h>

@interface GimbalExample()<GMBLBeaconManagerDelegate, GMBLPlaceManagerDelegate>

@property (nonatomic) GMBLPlaceManager *placeManager;
@property (nonatomic) GMBLBeaconManager *beaconManager;

@end

@implementation GimbalExample

-(id)init {
    self = [super init];
    if(self){
        [self setupGimbal];
    }
    return self;
}

-(void)setupGimbal {
    
    //
    // Example setup of interacting with Gimbal's SDK, and how it interacts with BVAdsSDK.
    // Note: This class will compile but probably won't work :-) Gimbal should be setup following their implementation guide.
    // GMBLBeaconManagerDelegate and GMBLPlaceManagerDelegate callbacks are detailed below with example data.
    
    
//    [Gimbal setAPIKey:@"PUT_YOUR_GIMBAL_API_KEY_HERE" options:nil];
    
    // example of both beacon manager and place manager -- usually not used together.
    // Shown here for example purposes :-)
    [self setupBeaconManager];
    [self setupPlaceManager];
}

-(void)setupBeaconManager {
    self.beaconManager = [GMBLBeaconManager new];
    self.beaconManager.delegate = self; // Needs to conform to GMBLBeaconManagerDelegate protocol
    [self.beaconManager startListening];
}

-(void)setupPlaceManager {
    self.placeManager = [GMBLPlaceManager new];
    self.placeManager.delegate = self; // Needs to conform to GMBLPlaceManagerDelegate protocol
    [GMBLPlaceManager startMonitoring];
}

#pragma mark - GMBLBeaconManagerDelegate

- (void)beaconManager:(GMBLBeaconManager *)manager didReceiveBeaconSighting:(GMBLBeaconSighting *)sighting
{
    //This will be invoked when a user sights a beacon
    [[BVAdsSDK sharedInstance] gimbalBeaconSighting:sighting.RSSI
                                               date:sighting.date
                                         identifier:sighting.beacon.identifier
                                               name:sighting.beacon.name
                                      interestTier1:tierOnePets
                                      interestTier2:tierTwoPetsDogs];
}

#pragma mark - GMBLPlaceManagerDelegate

- (void)placeManager:(GMBLPlaceManager *)manager didBeginVisit:(GMBLVisit *)visit
{
    // this will be invoked when a place is entered
    [[BVAdsSDK sharedInstance] gimbalPlaceBeginVisit:visit.arrivalDate
                                           dwellTime:visit.dwellTime
                                       departureDate:visit.departureDate
                                          identifier:visit.place.identifier
                                                name:visit.place.name
                                     contextualTier1:[visit.place.attributes stringForKey:@"ContextualTier1"]; // The contextual tier 1 interest associated with this place, like: "Home & Garden". See BVContextualInterest.h
                                     contextualTier2:[visit.place.attributes stringForKey:@"ContextualTier2"]];
}

- (void)placeManager:(GMBLPlaceManager *)manager didEndVisit:(GMBLVisit *)visit
{
    // this will be invoked when a place is exited
    [[BVAdsSDK sharedInstance] gimbalPlaceEndVisit:visit.arrivalDate
                                         dwellTime:visit.dwellTime
                                     departureDate:visit.departureDate
                                        identifier:visit.place.identifier
                                              name:visit.place.name
                                   contextualTier1:[visit.place.attributes stringForKey:@"ContextualTier1"]; // The contextual tier 1 interest associated with this place, like: "Home & Garden". See BVContextualInterest.h
                                   contextualTier2:[visit.place.attributes stringForKey:@"ContextualTier2"]];
}

- (void)placeManager:(GMBLPlaceManager *)manager didReceiveBeaconSighting:(GMBLBeaconSighting *)sighting forVisits:(NSArray *)visits
{
    // this will be invoked when a beacon assigned to a place within a current visit is sighted.
    for(GMBLVisit* visit in visits){
        [[BVAdsSDK sharedInstance] gimbalBeaconSightingForVisits:sighting.RSSI
                                                            date:sighting.date
                                                beaconIdentifier:sighting.beacon.identifier
                                                      beaconName:sighting.beacon.name
                                                     arrivalDate:visit.arrivalDate
                                                       dwellTime:visit.dwellTime
                                                   departureDate:visit.departureDate
                                                 visitIdentifier:visit.place.identifier
                                                       visitName:visit.place.name
                                                 contextualTier1:[visit.place.attributes stringForKey:@"ContextualTier1"]; // The contextual tier 1 interest associated with this place, like: "Home & Garden". See BVContextualInterest.h
                                                 contextualTier2:[visit.place.attributes stringForKey:@"ContextualTier2"]];
    }
}


@end
*/