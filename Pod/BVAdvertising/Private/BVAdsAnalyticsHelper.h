//
//  BVAdsAnalyticsHelper.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVAuthenticatedUser.h"
#import "BVAdInfo.h"

// 3rd Party
#import <GoogleMobileAds/GADRequestError.h>

/**
 *  Helper class wrapping BVAnalyticsManager that sends BV Advertising analytic events.
 */
@interface BVAdsAnalyticsHelper : NSObject

// ad lifecycle
-(void)adRequested:(BVAdInfo*)adInfo;
-(void)adReceived:(BVAdInfo*)adInfo;
-(void)adShown:(BVAdInfo*)adInfo;
-(void)adConversion:(BVAdInfo*)adInfo;
-(void)adDismissed:(BVAdInfo*)adInfo;
-(void)adFailed:(BVAdInfo*)adInfo error:(GADRequestError*)error;

@end
