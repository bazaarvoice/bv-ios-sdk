//
//  BVQuestionSubmissionResponse.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionResponse.h"
#import "BVSubmittedQuestion.h"
#import <Foundation/Foundation.h>

/// Successful question submission response.
@interface BVQuestionSubmissionResponse
    : BVSubmissionResponse <BVSubmittedQuestion *>
@end
