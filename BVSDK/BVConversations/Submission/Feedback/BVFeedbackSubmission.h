//
//  BVFeedbackSubmission.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmittedFeedback.h"
#import "BVBaseUGCSubmission.h"
#import <Foundation/Foundation.h>

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

/**
 Class to use to submit a feedback to the Bazaarvoice platform.

 You can use the submission request class to send helpfulness votes or flag
 inappropriate content for reviews, questions, or answers.

 For a description of possible fields see our API documentation at:
 https://developer.bazaarvoice.com/docs/read/conversations_api/reference/latest/feedback/submit

 @availability BVSDK 6.1.0 and later
 */

@interface BVFeedbackSubmission : BVBaseUGCSubmission <BVSubmittedFeedback *>

@property(nonnull) NSString *contentId;
@property BVFeedbackContentType contentType;
@property BVFeedbackType feedbackType;

@property BVFeedbackVote vote;
@property(nullable) NSString *reasonText;

- (nonnull instancetype)initWithContentId:(nonnull NSString *)contentId
                          withContentType:(BVFeedbackContentType)contentType
                         withFeedbackType:(BVFeedbackType)feedbackType;

- (nonnull instancetype)__unavailable init;

@end
