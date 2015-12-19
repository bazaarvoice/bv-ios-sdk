//
//  BVAdsAnalyticsHelper.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVAuthenticatedUser.h"
#import "BVGMBLSighting.h"
#import "BVGMBLVisit.h"
#import "BVAdInfo.h"
#import "BVLocationWrapper.h"

// 3rd Party
#import <GoogleMobileAds/GADRequestError.h>

/**
 *  Helper class wrapping BVAnalyticsManager that sends BV Advertising analytic events.
 */
@interface BVAdsAnalyticsHelper : NSObject

// ad lifecycle
-(void)adRequested:(BVAdInfo*)adInfo;
-(void)adDelivered:(BVAdInfo*)adInfo;
-(void)adShown:(BVAdInfo*)adInfo;
-(void)adFailed:(BVAdInfo*)adInfo error:(GADRequestError*)error;

// location updates
-(void)didEnterRegion:(CLCircularRegion*)region location:(BVLocationWrapper*)location;
-(void)didExitRegion:(CLCircularRegion*)region location:(BVLocationWrapper*)location;
-(void)didVisit:(CLVisit*)visit location:(BVLocationWrapper*)location;
-(void)didRangeBeacon:(CLBeacon*)beacon inRegion:(CLBeaconRegion*)region location:(BVLocationWrapper*)location;
-(void)didUpdateLocation:(BVLocationWrapper*)location;

// gimbal updates
-(void)gimbalSighting:(BVGMBLSighting*)sighting;
-(void)gimbalSighting:(BVGMBLSighting*)sighting forVisit:(BVGMBLVisit*)visit;
-(void)gimbalPlaceBeginVisit:(BVGMBLVisit*)visit;
-(void)gimbalPlaceEndVisit:(BVGMBLVisit*)visit;

@end
