//
//  BVFeedbackSubmissionResponse.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFeedbackSubmissionResponse.h"
#import "BVSubmissionResponse.h"
#import "BVSubmittedFeedback.h"
#import <Foundation/Foundation.h>

@interface BVFeedbackSubmissionResponse : BVSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@property(nullable) BVSubmittedFeedback *feedback;

@end
