//
//  BVAdInfo.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVAdInfo.h"

@implementation BVAdInfo

-(id)initWithAdUnitId:(NSString*)adUnitId adType:(BVAdType)adType {
    self = [super init];
    if(self) {
        self.adLoadId = arc4random() * arc4random();
        self.adUnitId = adUnitId;
        self.adType = adType;
    }
    return self;
}

-(NSString*)getFormattedAdType {
    switch (self.adType) {
        case BVInterstitial:
            return @"interstitial";
        case BVBanner:
            return @"banner";
        case BVNativeContent:
            return @"nativeContent";
        case BVNativeAppInstall:
            return @"nativeAppInstall";
        case BVNativeCustom:
            return @"nativeCustom";
        default:
            return @"";
    }
}

@end
