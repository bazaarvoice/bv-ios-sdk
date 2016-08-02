//
//  ReviewSubmission.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVReviewSubmissionResponse.h"
#import "BVSubmissionAction.h"
#import "BVConversationsRequest.h"

typedef void (^ReviewSubmissionCompletion)(BVReviewSubmissionResponse* _Nonnull response);

@interface BVReviewSubmission : NSObject

@property BVSubmissionAction action;

@property NSString* _Nullable user;
@property NSString* _Nullable userEmail;
@property NSString* _Nullable userId;
@property NSString* _Nullable userLocation;
@property NSString* _Nullable userNickname;

@property NSNumber* _Nullable agreedToTermsAndConditions;
@property NSNumber* _Nullable sendEmailAlertWhenCommented;
@property NSNumber* _Nullable sendEmailAlertWhenPublished;

@property NSString* _Nullable locale;
@property NSString* _Nullable campaignId;
@property NSString* _Nullable hostedAuthenticationEmail;
@property NSString* _Nullable hostedAuthenticationCallback;

@property NSString* _Nullable netPromoterComment;
@property NSNumber* _Nullable netPromoterScore;

@property NSNumber* _Nullable isRecommended;
@property NSString* _Nullable fingerPrint;

@property (readonly) NSString* _Nonnull productId;

-(nonnull instancetype)initWithReviewTitle:(nonnull NSString*)reviewTitle reviewText:(nonnull NSString*)reviewText rating:(NSUInteger)rating productId:(nonnull NSString*)productId;
-(nonnull instancetype) __unavailable init;
-(void)submit:(nonnull ReviewSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure;

-(void)addPhoto:(nonnull UIImage*)image withPhotoCaption:(nullable NSString*)photoCaption;

-(void)addAdditionalField:(nonnull NSString*)fieldName value:(nonnull NSString*)value;
-(void)addContextDataValueString:(nonnull NSString*)contextDataValueName value:(nonnull NSString*)value;
-(void)addContextDataValueBool:(nonnull NSString*)contextDataValueName value:(bool)value;
-(void)addRatingQuestion:(nonnull NSString*)ratingQuestionName value:(int)value;
-(void)addRatingSlider:(nonnull NSString*)ratingQuestionName value:(nonnull NSString*)value;
-(void)addPredefinedTagDimension:(nonnull NSString*)tagQuestionId tagId:(nonnull NSString*)tagId value:(nonnull NSString*)value;
-(void)addFreeformTagDimension:(nonnull NSString*)tagQuestionId tagNumber:(int)tagNumber value:(nonnull NSString*)value;

@end
