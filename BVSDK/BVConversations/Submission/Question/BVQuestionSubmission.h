//
//  BVQuestionSubmission.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBaseUGCSubmission.h"
#import "BVSubmittedQuestion.h"

/**
 Class to use to submit a question to the Bazaarvoice platform.

 Of the many parameters possible on a BVQuestionSubmission, the ones needed for
 submission depend on your specific implementation.

 For a description of possible fields see our API documentation at:
 https://developer.bazaarvoice.com/docs/read/conversations/questions/submit/5_4

 @availability 4.1.0 and later
 */
@interface BVQuestionSubmission : BVBaseUGCSubmission <BVSubmittedQuestion *>

/**
 Create a new BVQuestionSubmission.

 @param productId    The product ID that this question refers to.
 */
- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId;
- (nonnull instancetype)__unavailable init;

@property(nullable) NSString *questionSummary;
@property(nullable) NSString *questionDetails;

@property(nullable) NSNumber *isUserAnonymous;
@property(nullable) NSNumber *sendEmailAlertWhenAnswered;

@property(nonnull, readonly) NSString *productId;

@end
