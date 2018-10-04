//
//  BVPhotoSubmissionResponse.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionResponse.h"
#import "BVSubmittedPhoto.h"
#import <Foundation/Foundation.h>

@interface BVPhotoSubmissionResponse : BVSubmissionResponse <BVSubmittedPhoto *>

@end
