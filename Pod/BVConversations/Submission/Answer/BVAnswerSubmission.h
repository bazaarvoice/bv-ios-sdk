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


@interface BVAnswerSubmission : BVSubmission

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

-(nonnull instancetype)initWithQuestionId:(nonnull NSString*)questionId answerText:(nonnull NSString*)answerText;
-(nonnull instancetype) __unavailable init;

-(void)addPhoto:(nonnull UIImage*)image withPhotoCaption:(nullable NSString*)photoCaption;

-(void)submit:(nonnull AnswerSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure;

@end
