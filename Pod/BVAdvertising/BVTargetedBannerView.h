//
//  BVTargetedBannerView.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "BVTargetedRequest.h"

@interface BVTargetedBannerView : DFPBannerView

/**
 *  Generate a BVTargetedRequest, to be used with `loadRequest:`
 */
-(BVTargetedRequest*)getTargetedRequest;

@end
