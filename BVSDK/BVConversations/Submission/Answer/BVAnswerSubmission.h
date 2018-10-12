//
//  BVAnswerSubmission.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBaseUGCSubmission.h"
#import "BVSubmittedAnswer.h"

/**
 Class to use to submit an answer to the Bazaarvoice platform.

 Of the many parameters possible on a BVAnswerSubmission, the ones needed for
 submission depend on your specific implementation.

 For a description of possible fields see our API documentation at:
    https://developer.bazaarvoice.com/docs/read/conversations/answers/submit/5_4

 @availability 4.1.0 and later
 */
@interface BVAnswerSubmission : BVBaseUGCSubmission <BVSubmittedAnswer *>

/**
 Create a new BVAnswerSubmission.

 @param questionId    The ID of the question that this answer is associated
 with.
 @param answerText    The answer text that the user input.
 */
- (nonnull instancetype)initWithQuestionId:(nonnull NSString *)questionId
                                answerText:(nonnull NSString *)answerText;
- (nonnull instancetype)__unavailable init;

@property(nonnull, readonly) NSString *questionId;

@end
