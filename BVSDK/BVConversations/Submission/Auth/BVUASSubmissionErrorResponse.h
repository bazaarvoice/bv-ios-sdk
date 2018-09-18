//
//  BVUASSubmissionErrorResponse.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionErrorResponse.h"
#import "BVSubmittedUAS.h"
#import <Foundation/Foundation.h>

/// Failed UAS submission response
@interface BVUASSubmissionErrorResponse
    : BVSubmissionErrorResponse <BVSubmittedUAS *>
@end
