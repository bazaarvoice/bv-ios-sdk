//
//  BVReviewNotificationCenter.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVNotificationConstants.h"
#import "BVNotificationCenterObject.h"

@interface BVStoreReviewNotificationCenter : NSObject<BVStoreNotificationCenterObject>

-(id _Null_unspecified)init __attribute__((unavailable("Use sharedCenter")));

+(instancetype _Nonnull)sharedCenter;

@end
