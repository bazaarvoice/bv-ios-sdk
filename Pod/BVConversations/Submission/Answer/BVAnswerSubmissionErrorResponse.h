//
//  AnswerSubmissionErrorResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionErrorResponse.h"
#import "BVSubmittedAnswer.h"
#import <Foundation/Foundation.h>

/// Failed answer submission response.
@interface BVAnswerSubmissionErrorResponse : BVSubmissionErrorResponse

@property(nullable) BVSubmittedAnswer *answer;

@end
