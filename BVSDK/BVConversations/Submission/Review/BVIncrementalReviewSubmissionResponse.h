//
//  BVIncrementalReviewSubmissionResponse.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVSubmissionResponse.h"
#import "BVSubmittedIncrementalReview.h"

NS_ASSUME_NONNULL_BEGIN

@interface BVIncrementalReviewSubmissionResponse : BVSubmissionResponse <BVSubmittedIncrementalReview *>

@end

NS_ASSUME_NONNULL_END
