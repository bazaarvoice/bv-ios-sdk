//
//  BVSubmittedVideo.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 


#import "BVVideo.h"
#import "BVSubmittedType.h"

@interface BVSubmittedVideo : BVSubmittedType

@property(nonnull) BVVideo *video;

@end
