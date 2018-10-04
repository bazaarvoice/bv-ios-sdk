//
//  BVFeedbackSubmissionResponse.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionResponse.h"
#import "BVSubmittedFeedback.h"
#import <Foundation/Foundation.h>

@interface BVFeedbackSubmissionResponse
    : BVSubmissionResponse <BVSubmittedFeedback *>
@end
