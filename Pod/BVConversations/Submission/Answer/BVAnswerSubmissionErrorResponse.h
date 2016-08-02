//
//  AnswerSubmissionErrorResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSubmissionErrorResponse.h"
#import "BVSubmittedAnswer.h"

@interface BVAnswerSubmissionErrorResponse : BVSubmissionErrorResponse

@property BVSubmittedAnswer* _Nullable answer;

@end
