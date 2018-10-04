//
//  BVFeedbackSubmissionErrorResponse.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionErrorResponse.h"
#import "BVSubmittedFeedback.h"

@interface BVFeedbackSubmissionErrorResponse
    : BVSubmissionErrorResponse <BVSubmittedFeedback *>

@end
