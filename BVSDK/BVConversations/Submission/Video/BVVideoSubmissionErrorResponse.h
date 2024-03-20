//
//  BVVideoSubmissionErrorResponse.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import "BVSubmissionErrorResponse.h"
#import "BVSubmittedVideo.h"

@interface BVVideoSubmissionErrorResponse
    : BVSubmissionErrorResponse <BVSubmittedVideo *>

@end
