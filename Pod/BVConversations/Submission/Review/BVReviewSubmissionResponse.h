//
//  ReviewSubmissionResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSubmittedReview.h"
#import "BVSubmissionResponse.h"

@interface BVReviewSubmissionResponse : BVSubmissionResponse

@property BVSubmittedReview* _Nullable review;

@end
