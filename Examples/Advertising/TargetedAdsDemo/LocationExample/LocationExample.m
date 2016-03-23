//
//  LocationListener.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "LocationExample.h"
#import <CoreLocation/CoreLocation.h>
#import <BVSDK/BVSDK.h>

@interface LocationExample()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationExample

-(id)init {
    self = [super init];
    if(self){
        [self setupLocationManager];
    }
    return self;
}

-(void)setupLocationManager {
    
    /*
        Example setup of CLLocationManager, and how they interact with BVAdsSDK.
        Note: This class will compile but probably won't work :-) Example usage only.
        Some CLLocationManagerDelegate callbacks are detailed below with example data.
     */
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    // TODO: Add NSLocationAlwaysUsageDescription in .plist and give it a string
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    /*
        Let's assume that this region represents the Women's dresses section of a Macy's.
        In this scenario, tell BVAdsSDK that the user entered this region using `tierOneApparelAndAccessories`
        and `tierTwoApparelAndAccessoriesWomensDresses` to describe what this event corresponds to, as shown below.
     */
    [BVLocationEventsHelper locationManager:manager
                                didEnterRegion:(CLCircularRegion*)region
                               contextualTier1:tierOneApparelAndAccessories
                               contextualTier2:tierTwoApparelAndAccessoriesWomensDresses];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    /*
        Let's assume that this region represents the coffe shop Starbuck's.
        In this scenario, tell BVAdsSDK about this event with the contextual interest tier 1 `tierOneFoodAndDrink`
        and contextual interest tier 2 `tierTwoFoodAndDrinkCoffeeTea`, as shown below.
     */
    [BVLocationEventsHelper locationManager:manager
                                 didExitRegion:(CLCircularRegion*)region
                               contextualTier1:tierOneFoodAndDrink
                               contextualTier2:tierTwoFoodAndDrinkCoffeeTea];
}

-(void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    
    /*
        Let's assume that this CLVisit represents visiting the TV section of a BestBuy store.
        In this scenario, tell BVAdsSDK about this event with `tierOneConsumerElectronics`
        and `tierTwoConsumerElectronicsTelevisions`, as shown below.
     */
    [BVLocationEventsHelper locationManager:manager
                                      didVisit:visit
                               contextualTier1:tierOneConsumerElectronics
                               contextualTier2:tierTwoConsumerElectronicsTelevisions];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation* lastLocation = [locations lastObject];
    
    /*
        Let's assume that this location event represents the dog section of a pet store.
        In this scenario, tell BVAdsSDK about this event with `tierOnePets` 
        and `tierTwoPetsDogs`, as shown below.
     */
    
    [BVLocationEventsHelper locationManager:manager
                             didUpdateLocation:lastLocation
                               contextualTier1:tierOnePets
                               contextualTier2:tierTwoPetsDogs];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    // different beacons may have different location interests associated with them, in this region.
    // so this is available to call with only one beacon, not a list as passed in via CLLocationManagerDelegate
    // example:
    for(CLBeacon* beacon in beacons){
        
        // ...
        // BVContextualInterest* tier1Interest = [self getTier1ForBeacon:beacon]; // get the appropriate tier interest for this beacon (example)
        // BVContextualInterest* tier2Interest = [self getTier2ForBeacon:beacon];
        // ...
        [BVLocationEventsHelper locationManager:manager
                                    didRangeBeacon:beacon
                                          inRegion:region
                                   contextualTier1:tierOneConsumerElectronics // just an example -- should assign appropriate contextual interests based on where the beacon is inside a store
                                   contextualTier2:tierTwoConsumerElectronicsAudio];
    }
}

@end
