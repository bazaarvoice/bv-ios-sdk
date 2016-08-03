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


/**
 Class to use to submit a review to the Bazaarvoice platform.
 
 Of the many parameters possible on a BVReviewSubmission, the ones needed for submission depend on your specific implementation.
 
 For a description of possible fields see our API documentation at:
 https://developer.bazaarvoice.com/docs/read/conversations/reviews/submit/5_4
 
 @availability 4.1.0 and later
 */
@interface BVReviewSubmission : NSObject

/**
 Create a new BVReviewSubmission.
 
 @param reviewTitle    The user-provided title of the review.
 @param reviewText     The user-provided body of the review.
 @param rating         The user-provided rating: 1-5.
 @param productId      The productId that this review is associated with.
 */
-(nonnull instancetype)initWithReviewTitle:(nonnull NSString*)reviewTitle reviewText:(nonnull NSString*)reviewText rating:(NSUInteger)rating productId:(nonnull NSString*)productId;
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
-(void)submit:(nonnull ReviewSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure;


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

-(void)addAdditionalField:(nonnull NSString*)fieldName value:(nonnull NSString*)value;
-(void)addContextDataValueString:(nonnull NSString*)contextDataValueName value:(nonnull NSString*)value;
-(void)addContextDataValueBool:(nonnull NSString*)contextDataValueName value:(bool)value;
-(void)addRatingQuestion:(nonnull NSString*)ratingQuestionName value:(int)value;
-(void)addRatingSlider:(nonnull NSString*)ratingQuestionName value:(nonnull NSString*)value;
-(void)addPredefinedTagDimension:(nonnull NSString*)tagQuestionId tagId:(nonnull NSString*)tagId value:(nonnull NSString*)value;
-(void)addFreeformTagDimension:(nonnull NSString*)tagQuestionId tagNumber:(int)tagNumber value:(nonnull NSString*)value;

@end
