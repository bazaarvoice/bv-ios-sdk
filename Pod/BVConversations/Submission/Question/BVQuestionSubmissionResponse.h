//
//  QuestionSubmissionResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSubmittedQuestion.h"
#import "BVSubmissionResponse.h"

/// Successful question submission response.
@interface BVQuestionSubmissionResponse : BVSubmissionResponse

@property BVSubmittedQuestion* _Nullable question;

@end
