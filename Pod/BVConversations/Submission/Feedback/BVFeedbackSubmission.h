//
//  BVFeedbackSubmission.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVFeedbackSubmissionResponse.h"
#import "BVSubmission.h"
#import "BVSubmissionAction.h"
#import "BVSubmissionErrorResponse.h"

/*
 Types of Bazaarvoice content supplying feedback on.
 */
typedef NS_ENUM(NSInteger, BVFeedbackContentType) {
  BVFeedbackContentTypeReview,
  BVFeedbackContentTypeQuestion,
  BVFeedbackContentTypeAnswer
};

/*
 Types of feedback.
 */
typedef NS_ENUM(NSInteger, BVFeedbackType) {
  BVFeedbackTypeInappropriate,
  BVFeedbackTypeHelpfulness
};

/*
 Feedback vote.
 */
typedef NS_ENUM(NSInteger, BVFeedbackVote) {
  BVFeedbackVotePositive,
  BVFeedbackVoteNegative
};

typedef void (^FeedbackSubmissionCompletion)(
    BVFeedbackSubmissionResponse *__nonnull response);

/**
 Class to use to submit a feedback to the Bazaarvoice platform.

 You can use the submission request class to send helpfulness votes or flag
 inappropriate content for reviews, questions, or answers.

 For a description of possible fields see our API documentation at:
 https://developer.bazaarvoice.com/docs/read/conversations_api/reference/latest/feedback/submit

 @availability BVSDK 6.1.0 and later
 */

@interface BVFeedbackSubmission : BVSubmission

@property(nonnull) NSString *contentId;
@property BVFeedbackContentType contentType;
@property BVFeedbackType feedbackType;

@property BVFeedbackVote vote;
@property(nonnull) NSString *userId;
@property(nullable) NSString *reasonText;

- (nonnull instancetype)initWithContentId:(nonnull NSString *)contentId
                          withContentType:(BVFeedbackContentType)contentType
                         withFeedbackType:(BVFeedbackType)feedbackType;

- (nonnull instancetype)__unavailable init;

/**
 Submit feedback to the Bazaarvoice platform.

 A submission can fail for many reasons, and is dependent on your submission
 configuration.

 @param success    The success block is called when a successful submission
 occurs.
 @param failure    The failure block is called when an unsuccessful submission
 occurs. This could be for a number of reasons: network failures, submission
 parameters invalid, or server errors occur.
 */
- (void)submit:(nonnull FeedbackSubmissionCompletion)success
       failure:(nonnull ConversationsFailureHandler)failure;

@end
