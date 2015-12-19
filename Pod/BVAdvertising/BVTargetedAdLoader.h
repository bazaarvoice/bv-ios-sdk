//
//  BVTargetedAdLoader.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "BVTargetedRequest.h"

@interface BVTargetedAdLoader: GADAdLoader<GADAdLoaderDelegate>

/**
 *  Generate a BVTargetedRequest, to be used with `loadRequest:`.
 */
-(BVTargetedRequest*)getTargetedRequest;


@end
