//
//  BVLocationEventsHelper.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h> // for handling beacon/geofence updates
#import "BVLogger.h"
#import "BVAuthenticatedUser.h"
#import "BVGMBLVisit.h"
#import "BVGMBLSighting.h"
#import "BVContextualInterests.h"

/// Static helper routes to post location-aware events.
@interface BVLocationEventsHelper : NSObject


/*!
    Record the device entering a beacon/geofence region.
    @param manager The CLLocationManager object used in determining location.
    @param region The geofence or beacon region entered.
    @param tier1 the BV-specified tier 1 interest associated with this region. See BVContextualInterests.h
    @param tier2 the BV-specified tier 2 interest associated with this region. See BVContextualInterests.h
 */
+(void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLCircularRegion *)region contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2;


/*!
    Record the device exiting a beacon/geofence region.
    @param manager The CLLocationManager object used in determining location.
    @param region The geofence or beacon region entered.
    @param tier1 the BV-specified tier 1 interest associated with this region. See BVContextualInterests.h
    @param tier2 the BV-specified tier 2 interest associated with this region. See BVContextualInterests.h
 */
+(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLCircularRegion *)region contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2;


/*!
    Record the device visiting a location.
    @param manager The CLLocationManager object used in determining location.
    @param visit The visit object that the device entered.
    @param tier1 the BV-specified tier 1 interest associated with this visit. See BVContextualInterests.h
    @param tier2 the BV-specified tier 2 interest associated with this visit. See BVContextualInterests.h
 */
+(void)locationManager:(CLLocationManager*)manager didVisit:(CLVisit *)visit contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2;


/*!
    Record the ranging a beacon. This should be called for every beacon ranged in locationDidRangeBeacon:inRegion in CLLocationManagerDelegate.
    @param manager The CLLocationManager object used in determining location.
    @param beacon The CLBeacon object that was ranged
    @param region The CLBeaconRegion object that was ranged
    @param tier1 the BV-specified tier 1 interest associated with this location. See BVContextualInterests.h
    @param tier2 the BV-specified tier 2 interest associated with this location. See BVContextualInterests.h
 */
+(void)locationManager:(CLLocationManager*)manager didRangeBeacon:(CLBeacon*)beacon inRegion:(CLBeaconRegion*)region contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2;

/*!
    Record the user location. This should be called for ever location update in locationDidUpdateLocations: in CLLocationManagerDelegate.
    @param manager The CLLocationManager object used in determining location.
    @param location The CLLocation object that was updated.
    @param tier1 the BV-specified tier 1 interest associated with this location. See BVContextualInterests.h
    @param tier2 the BV-specified tier 2 interest associated with this location. See BVContextualInterests.h
 */
+(void)locationManager:(CLLocationManager*)manager didUpdateLocation:(CLLocation*)location contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2;


/*!
    Record the device receiving a gimbal beacon sighting event. This method has a direct correlation to beaconManager:didReceiveBeaconSighting:
    @param RSSI The RSSI (signal strength) of the beacon sighting.
    @param date The NSDate that the sighting occured
    @param identifier The GMBLBeacon's factory ID.
    @param name The GMBLBeacon's name, assigned via the Gimbal Manager
    @param tier1 the BV-specified tier 1 interest associated with this sighting. See BVContextualInterests.h
    @param tier2 the BV-specified tier 2 interest associated with this sighting. See BVContextualInterests.h
 */
+(void)gimbalBeaconSighting:(NSInteger)RSSI date:(NSDate*)date identifier:(NSString*)identifier name:(NSString*)name contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2;


/*!
    Record the device beginning a gimbal visit. This directly correlates to GMBLPlaceManagerDelegate's placeManager:didBeginVisit: method.
    @param arrivalDate Taken from the GMBLVisit object.
    @param dwellTime Taken from the GMBLVisit object.
    @param departureDate Taken from the GMBLVisit object.
    @param identifier Taken from GMBLPlace object.
    @param name Taken from GMBLPlace object.
    @param tier1 the BV-specified tier 1 interest associated with this visit. See BVContextualInterests.h
    @param tier2 the BV-specified tier 2 interest associated with this visit. See BVContextualInterests.h
 */
+(void)gimbalPlaceBeginVisit:(NSDate*)arrivalDate dwellTime:(NSTimeInterval)dwellTime departureDate:(NSDate*)departureDate identifier:(NSString*)identifier name:(NSString*)name contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2;


/*!
    Record the device exiting a gimbal visit. This directly correlates to GMBLPlaceManagerDelegate's placeManager:didEndVisit: method. See gimbalPlaceBeginVisit:dwellTime:departureTime:identifier:name:attributes for details on this method.
 */
+(void)gimbalPlaceEndVisit:(NSDate*)arrivalDate dwellTime:(NSTimeInterval)dwellTime departureDate:(NSDate*)departureDate identifier:(NSString*)identifier name:(NSString*)name contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2;


/*!
    Record the device receiving a gimbal beacon sighting event. This method has a direct correlation to placeManager:didReceiveBeaconSighting:forVisits:. All parameters (lol, so many) are detailed in the gimbalBeaconSighting: and gimbalPlaceBeginVisit: methods of this SDK, as this event is a combination of those two.
 */
+(void)gimbalBeaconSightingForVisits:(NSInteger)RSSI date:(NSDate*)date beaconIdentifier:(NSString*)beaconIdentifier beaconName:(NSString*)beaconName arrivalDate:(NSDate*)arrivalDate dwellTime:(NSTimeInterval)dwellTime departureDate:(NSDate*)departureDate visitIdentifier:(NSString*)visitIdentifier visitName:(NSString*)visitName contextualTier1:(BVContextualInterest*)tier1 contextualTier2:(BVContextualInterest*)tier2;

@end
