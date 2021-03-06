//
//  BVQuestionSubmissionErrorResponse.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionErrorResponse.h"
#import "BVSubmittedQuestion.h"
#import <Foundation/Foundation.h>

/// Failed question submission response.
@interface BVQuestionSubmissionErrorResponse
    : BVSubmissionErrorResponse <BVSubmittedQuestion *>
@end
