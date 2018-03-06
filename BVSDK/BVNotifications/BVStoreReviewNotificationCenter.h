//
//  BVReviewNotificationCenter.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVNotificationCenterObject.h"
#import "BVNotificationConstants.h"

@interface BVStoreReviewNotificationCenter
    : NSObject <BVStoreNotificationCenterObject>

- (id _Null_unspecified)init __attribute__((unavailable("Use sharedCenter")));

+ (nonnull instancetype)sharedCenter;

@end
