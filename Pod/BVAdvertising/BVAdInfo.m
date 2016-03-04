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
            return @"Interstitial";
        case BVBanner:
            return @"Banner";
        case BVNativeContent:
            return @"Native";
        case BVNativeAppInstall:
            return @"Native";
        case BVNativeCustom:
            return @"NativeCustom";
        default:
            return @"";
    }
}

@end
