//
//  AnswerSubmissionResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSubmittedAnswer.h"
#import "BVSubmissionResponse.h"

@interface BVAnswerSubmissionResponse : BVSubmissionResponse

@property BVSubmittedAnswer* _Nullable answer;

@end
