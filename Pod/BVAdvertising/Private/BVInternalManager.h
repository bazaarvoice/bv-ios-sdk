//
//  BVInternalManager.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVLogger.h"
#import "BVAuthenticatedUser.h"
#import "BVAdInfo.h"
#import "BVTargetedInterstitial.h"
#import "BVTargetedBannerView.h"
#import "BVTargetedAdLoader.h"

@interface BVInternalManager : NSObject

+(instancetype)sharedInstance;

-(void)maybeUpdateUserProfile;
-(void)setUserId:(NSString*)userAuthString;

// ad lifecycle
-(void)adRequested:(BVAdInfo*)adInfo;
-(void)adReceived:(BVAdInfo*)adInfo;
-(void)adDismissed:(BVAdInfo*)adInfo;
-(void)adConversion:(BVAdInfo*)adInfo;

-(void)adShown:(BVAdInfo*)adInfo;
-(void)nativeAdShown:(GADNativeAd*)nativeAd;
-(void)nativeAdConversion:(GADNativeAd*)nativeAd;

-(void)adFailed:(BVAdInfo*)adInfo error:(GADRequestError*)error;
-(void)trackNativeAd:(GADNativeAd*)nativeAd withAdLoaderInfo:(BVAdInfo*)adLoaderInfo;
-(BVAdInfo*)getAdInfoForNativeAd:(GADNativeAd*)nativeAd;


@end
