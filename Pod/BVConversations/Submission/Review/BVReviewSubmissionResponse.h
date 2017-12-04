//
//  BVReviewSubmissionResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionResponse.h"
#import "BVSubmittedReview.h"
#import <Foundation/Foundation.h>

/// Successful review submission response.
@interface BVReviewSubmissionResponse : BVSubmissionResponse

@property(nullable) BVSubmittedReview *review;

@end
