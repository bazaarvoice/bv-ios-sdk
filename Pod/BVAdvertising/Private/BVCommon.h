//
//  BVCommon.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BVAdType) {
    BVInterstitial,
    BVBanner,
    BVNativeContent,
    BVNativeAppInstall,
    BVNativeCustom
};

@interface BVCommon : NSObject

@end
