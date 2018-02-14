//
//  BVQuestionSubmission.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBaseUGCSubmission.h"
#import "BVConversationsRequest.h"
#import "BVQuestionSubmissionResponse.h"
#import "BVSubmissionAction.h"
#import "BVUploadablePhoto.h"
#import <Foundation/Foundation.h>

typedef void (^QuestionSubmissionCompletion)(
    BVQuestionSubmissionResponse *__nonnull response);

/**
 Class to use to submit a question to the Bazaarvoice platform.

 Of the many parameters possible on a BVQuestionSubmission, the ones needed for
 submission depend on your specific implementation.

 For a description of possible fields see our API documentation at:
 https://developer.bazaarvoice.com/docs/read/conversations/questions/submit/5_4

 @availability 4.1.0 and later
 */
@interface BVQuestionSubmission : BVBaseUGCSubmission

/**
 Create a new BVQuestionSubmission.

 @param productId    The product ID that this question refers to.
 */
- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId;
- (nonnull instancetype)__unavailable init;

/**
 Submit this answer to the Bazaarvoice platform. If the `action` of this object
 is set to `BVSubmissionActionPreview` then the submission will NOT actually
 take place.

 A submission can fail for many reasons, and is dependent on your submission
 configuration.

 @param success    The success block is called when a successful submission
 occurs.
 @param failure    The failure block is called when an unsuccessful submission
 occurs. This could be for a number of reasons: network failures, submission
 parameters invalid, or server errors occur.
 */
- (void)submit:(nonnull QuestionSubmissionCompletion)success
       failure:(nonnull ConversationsFailureHandler)failure;

@property(nullable) NSString *questionSummary;
@property(nullable) NSString *questionDetails;

@property(nullable) NSNumber *isUserAnonymous;

@property(nullable) NSNumber *sendEmailAlertWhenAnswered;

@property(nonnull, readonly) NSString *productId;

@end
