//
//  QuestionSubmission.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSubmissionAction.h"
#import "BVUploadablePhoto.h"
#import "BVQuestionSubmissionResponse.h"
#import "BVConversationsRequest.h"
#import "BVSubmission.h"


typedef void (^QuestionSubmissionCompletion)(BVQuestionSubmissionResponse* _Nonnull response);


@interface BVQuestionSubmission : BVSubmission

@property BVSubmissionAction action;
@property NSString* _Nullable questionSummary;
@property NSString* _Nullable questionDetails;

@property NSString* _Nullable user;
@property NSString* _Nullable userEmail;
@property NSString* _Nullable userId;
@property NSString* _Nullable userLocation;
@property NSString* _Nullable userNickname;

@property NSString* _Nullable campaignId;
@property NSString* _Nullable fingerPrint;
@property NSString* _Nullable hostedAuthenticationEmail;
@property NSString* _Nullable hostedAuthenticationCallback;
@property NSString* _Nullable locale;

@property NSNumber* _Nullable isUserAnonymous;
@property NSNumber* _Nullable agreedToTermsAndConditions;

@property NSNumber* _Nullable sendEmailAlertWhenPublished;
@property NSNumber* _Nullable sendEmailAlertWhenAnswered;

@property (readonly) NSString* _Nonnull productId;

-(nonnull instancetype)initWithProductId:(nonnull NSString*)productId;
-(nonnull instancetype) __unavailable init;

-(void)addPhoto:(nonnull UIImage*)image withPhotoCaption:(nullable NSString*)photoCaption;
-(void)submit:(nonnull QuestionSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure;

@end
