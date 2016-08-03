//
//  ReviewSubmissionErrorResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSubmissionErrorResponse.h"
#import "BVSubmittedReview.h"

/// Failed review submission response.
@interface BVReviewSubmissionErrorResponse : BVSubmissionErrorResponse

@property BVSubmittedReview* _Nullable review;

@end
