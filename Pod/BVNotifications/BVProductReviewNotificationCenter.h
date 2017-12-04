//
//  BVProductReviewNotificationCenter.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//
#import "BVNotificationCenterObject.h"
#import "BVPIN.h"
#import "BVProduct.h"
#import <Foundation/Foundation.h>

@interface BVProductReviewNotificationCenter
    : NSObject <BVProductNotificationCenterObject>

- (id _Null_unspecified)init __attribute__((unavailable("Use sharedCenter")));

+ (nonnull instancetype)sharedCenter;

@end
