//
//  BVProductReviewNotificationCenter.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//
#import <Foundation/Foundation.h>
#import "BVNotificationCenterObject.h"
#import "BVPIN.h"
#import "BVProduct.h"

@interface BVProductReviewNotificationCenter : NSObject<BVProductNotificationCenterObject>

-(id _Null_unspecified)init __attribute__((unavailable("Use sharedCenter")));

+(instancetype _Nonnull)sharedCenter;

@end
