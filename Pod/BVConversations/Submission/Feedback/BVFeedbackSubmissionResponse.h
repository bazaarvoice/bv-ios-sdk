//
//  BVFeedbackSubmissionResponse.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSubmittedFeedback.h"
#import "BVFeedbackSubmissionResponse.h"
#import "BVSubmissionResponse.h"

@interface BVFeedbackSubmissionResponse : BVSubmissionResponse

-(nonnull instancetype)initWithApiResponse:(NSDictionary * _Nonnull )apiResponse;

@property BVSubmittedFeedback* _Nullable feedback;

@end
