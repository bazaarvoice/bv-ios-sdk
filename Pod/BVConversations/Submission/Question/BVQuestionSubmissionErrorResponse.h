//
//  BVQuestionSubmissionErrorResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSubmissionErrorResponse.h"
#import "BVSubmittedQuestion.h"

/// Failed question submission response.
@interface BVQuestionSubmissionErrorResponse : BVSubmissionErrorResponse

@property BVSubmittedQuestion* _Nullable question;

@end
