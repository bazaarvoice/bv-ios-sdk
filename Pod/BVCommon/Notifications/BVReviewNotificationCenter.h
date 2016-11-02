//
//  BVReviewNotificationCenter.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVNotificationConstants.h"
#import "BVNotificationCenterObject.h"

@interface BVReviewNotificationCenter : NSObject<BVNotificationCenterObject>

+(instancetype _Nonnull)sharedCenter;

-(id _Null_unspecified)init __attribute__((unavailable("Use sharedCenter")));

@end
