//
//  BVReviewSubmission.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVReviewSubmissionResponse.h"
#import "BVSubmissionAction.h"
#import "BVConversationsRequest.h"
#import "BVUploadablePhoto.h"
#import "BVSubmission.h"

typedef void (^ReviewSubmissionCompletion)(BVReviewSubmissionResponse* _Nonnull response);


/**
 Class to use to submit a review to the Bazaarvoice platform.
 
 Of the many parameters possible on a BVReviewSubmission, the ones needed for submission depend on your specific implementation.
 
 For a description of possible fields see our API documentation at:
 https://developer.bazaarvoice.com/docs/read/conversations/reviews/submit/5_4
 
 @availability 4.1.0 and later
 */
@interface BVReviewSubmission : BVSubmission

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

/**
 Set whether or not to to perform a preview on the submission or submit for real. Default is BVSubmissionActionPreview.
 A preview is like a dry run, but validation of the fields will occur through the API call over the network but no data will be submitted.

 */
@property BVSubmissionAction action;

/// Value of the encrypted user. This parameter demonstrates that a user has been authenticated. Note that the UserId parameter does not contain authentication information and should not be used for hosted authentication. See the Authenticate User method for more information.
@property NSString* _Nullable user;

/// User's email address
@property NSString* _Nullable userEmail;

/// User's external ID. Do not use email addresses for this value.
@property NSString* _Nullable userId;

/// User location text
@property NSString* _Nullable userLocation;

/// User nickname display text
@property NSString* _Nullable userNickname;

/// Boolean indicating whether or not the user agreed to the terms and conditions. Required depending on the client's settings.
@property NSNumber* _Nullable agreedToTermsAndConditions;

// Boolean indicating whether or not the user wants to be notified when a comment is posted on the content.
@property NSNumber* _Nullable sendEmailAlertWhenCommented;

/// Boolean indicating whether or not the user wants to be notified when his/her content is published.
@property NSNumber* _Nullable sendEmailAlertWhenPublished;

/// Locale to display Labels, Configuration, Product Attributes and Category Attributes in. The default value is the locale defined in the display associated with the API key.
@property NSString* _Nullable locale;

/// Arbitrary text that may be saved alongside content to indicate vehicle by which content was captured, e.g. “post-purchase email”.
@property NSString* _Nullable campaignId;

/// Email address where the submitter will receive the confirmation email. If you are configured to use hosted email authentication, this parameter is required. See the Authenticate User method for more information on hosted authentication.
@property NSString* _Nullable hostedAuthenticationEmail;

/// URL of the link contained in the user authentication email. This should point to a landing page where a web application exists to complete the user authentication process. The host for the URL must be one of the domains configured for the client. The link in the email will contain a user authentication token (authtoken) that is used to verify the submitter. If you are configured to use hosted email authentication, this parameter is required. See the hosted authentication tutorial for more information.
@property NSString* _Nullable hostedAuthenticationCallback;

/// Value is text representing a user comment to explain numerical Net Promoter score.
@property NSString* _Nullable netPromoterComment;

/// Value is positive integer between 1 and 10 representing a numerical rating in response to “How would you rate this company?”
@property NSNumber* _Nullable netPromoterScore;

/// Value is true or false; default is null – "true" or "false" answer to "I would recommend this to a friend". Required dependent on client settings.
@property NSNumber* _Nullable isRecommended;

/**
 Fingerprint of content author's device. See the Authenticity Tutorial for more information.
 
 Per the Bazaarvoice Authenticity Policy, you must send a device fingerprint attached to each submission. If you fail to send a device fingerprint with your submission, Bazaarvoice may take any action deemed necessary in Bazaarvoice’s sole discretion to protect the integrity of the network. Such actions may include but are not limited to: rejection of your content, halting syndication of your content on the Bazaarvoice network, revocation of your API key, or revocation of your API license.
 */
@property NSString* _Nullable fingerPrint;

/// An array of BVUploadablePhoto objects to attach to a review submission.
@property NSMutableArray<BVUploadablePhoto*>* _Nonnull photos;

/// The product id used to filter the review on.
@property (readonly) NSString* _Nonnull productId;

-(void)addAdditionalField:(nonnull NSString*)fieldName value:(nonnull NSString*)value;
-(void)addContextDataValueString:(nonnull NSString*)contextDataValueName value:(nonnull NSString*)value;
-(void)addContextDataValueBool:(nonnull NSString*)contextDataValueName value:(bool)value;
-(void)addRatingQuestion:(nonnull NSString*)ratingQuestionName value:(int)value;
-(void)addRatingSlider:(nonnull NSString*)ratingQuestionName value:(nonnull NSString*)value;
-(void)addPredefinedTagDimension:(nonnull NSString*)tagQuestionId tagId:(nonnull NSString*)tagId value:(nonnull NSString*)value;
-(void)addFreeformTagDimension:(nonnull NSString*)tagQuestionId tagNumber:(int)tagNumber value:(nonnull NSString*)value;
- (NSString * _Nonnull)getPasskey;

@end
