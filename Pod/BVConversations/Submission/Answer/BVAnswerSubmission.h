//
//  BVAnswerSubmission.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVSubmissionAction.h"
#import "BVAnswerSubmissionResponse.h"
#import "BVConversationsRequest.h"
#import "BVSubmission.h"


typedef void (^AnswerSubmissionCompletion)(BVAnswerSubmissionResponse* _Nonnull response);

/**
 Class to use to submit an answer to the Bazaarvoice platform.
 
 Of the many parameters possible on a BVAnswerSubmission, the ones needed for submission depend on your specific implementation.
 
 For a description of possible fields see our API documentation at: 
    https://developer.bazaarvoice.com/docs/read/conversations/answers/submit/5_4
 
 @availability 4.1.0 and later
 */
@interface BVAnswerSubmission : BVSubmission

/**
 Create a new BVAnswerSubmission.
 
 @param questionId    The ID of the question that this answer is associated with.
 @param answerText    The answer text that the user input.
 */
-(nonnull instancetype)initWithQuestionId:(nonnull NSString*)questionId answerText:(nonnull NSString*)answerText;
-(nonnull instancetype) __unavailable init;

/**
 Submit a user-provided photo attached to this answer.
 
 @param image           The user-provded image attached to this answer.
 @param photoCaption    The user-provided caption for the photo.
 */
-(void)addPhoto:(nonnull UIImage*)image withPhotoCaption:(nullable NSString*)photoCaption;

/**
 Submit this answer to the Bazaarvoice platform. If the `action` of this object is set to `BVSubmissionActionPreview` then the submission will NOT actually take place.
 
 A submission can fail for many reasons, and is dependent on your submission configuration.
 
 @param success    The success block is called when a successful submission occurs.
 @param failure    The failure block is called when an unsuccessful submission occurs. This could be for a number of reasons: network failures, submission parameters invalid, or server errors occur.
 */
-(void)submit:(nonnull AnswerSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure;

@property BVSubmissionAction action;

@property NSString* _Nullable user;
@property NSString* _Nullable userEmail;
@property NSString* _Nullable userId;
@property NSString* _Nullable userLocation;
@property NSString* _Nullable userNickname;

@property NSNumber* _Nullable agreedToTermsAndConditions;
@property NSNumber* _Nullable sendEmailAlertWhenPublished;

@property NSString* _Nullable locale;
@property NSString* _Nullable campaignId;
@property NSString* _Nullable hostedAuthenticationEmail;
@property NSString* _Nullable hostedAuthenticationCallback;

@property NSString* _Nullable fingerPrint;

@property (readonly) NSString* _Nonnull questionId;

@end
