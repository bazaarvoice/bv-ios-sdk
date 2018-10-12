//
//  BVPhotoSubmissionErrorResponse.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionErrorResponse.h"
#import "BVSubmittedPhoto.h"

@interface BVPhotoSubmissionErrorResponse
    : BVSubmissionErrorResponse <BVSubmittedPhoto *>

@end
