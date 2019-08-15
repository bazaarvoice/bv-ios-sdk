//
//  BVIncrementalReviewSubmission.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVSubmission.h"
#import "BVConversations.h"
#import "BVSubmissionResponse.h"
#import "BVSubmittedIncrementalReview.h"

NS_ASSUME_NONNULL_BEGIN 

@interface BVIncrementalReviewSubmission : BVSubmission <BVSubmittedIncrementalReview *>

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                         submissionFields:(nonnull NSDictionary *)submissionFields
                                userToken:(nonnull NSString *)userToken;

@end

NS_ASSUME_NONNULL_END
