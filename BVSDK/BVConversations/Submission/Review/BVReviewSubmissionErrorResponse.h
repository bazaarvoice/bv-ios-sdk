//
//  BVReviewSubmissionErrorResponse.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionErrorResponse.h"
#import "BVSubmittedReview.h"
#import <Foundation/Foundation.h>

/// Failed review submission response.
@interface BVReviewSubmissionErrorResponse
    : BVSubmissionErrorResponse <BVSubmittedReview *>
@end
