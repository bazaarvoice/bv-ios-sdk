//
//  BVVideoSubmissionResponse.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import "BVSubmissionResponse.h"
#import "BVSubmittedVideo.h"
#import <Foundation/Foundation.h>

@interface BVVideoSubmissionResponse : BVSubmissionResponse <BVSubmittedVideo *>

@end
