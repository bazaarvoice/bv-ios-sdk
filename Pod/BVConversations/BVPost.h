//
//  BVPost.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BVConstants.h"
#import "BVDelegate.h"

/*!
    BVPost is used for all requests to the Bazaarvoice API which submit content excluding photo and video uploads.  This includes submitting answers, review comments, story comments, feedback, questions, reviews and stories.
 
    In the simplest case, a request might be created as follows:
 
    @code
    BVPost *questionRequest = [[BVPost alloc] initWithType:BVPostTypeQuestion];
    questionRequest.categoryId = @"1020";
    ...
    [questionRequest sendRequestWithDelegate:self];
    @endcode

    The specified delegate will then receive BVDelegate callbacks when a response is received.  Note that it is the client's responsibility to set the delegate to nil in the case that the the delegate is deallocated before a response is received.
 */
@interface BVPost : NSObject


/*!
    Convenience initializer with type.
    @param type The particular type (BVPostTypeReview, BVPostTypeAnswer...) of this request.
 */
- (id)initWithType:(BVPostType)type;


/// The particular type (BVPostTypeReview, BVPostTypeAnswer...) of this request.
@property (assign, nonatomic) BVPostType type;


/// The client delegate to receive BVDelegate notifications.
@property (weak) id<BVDelegate> delegate;


/// The URL that this request was sent to.  Is only available after the request has been sent.
@property (assign, nonatomic) NSString *requestURL;


/***** Used by All Types of BVPost Requests *******/


/// The submission action to take -- either BVActionPreview or BVActionSubmit. 'BVActionPreview' will show a draft of the content to be submitted; 'BVActionSubmit' will submit the content.
@property (assign, nonatomic) BVAction action;


/// Boolean indicating whether or not the user agreed to the terms and conditions.  Required depending on the client's settings.
@property (assign, nonatomic) BOOL agreedToTermsAndConditions;


/// Arbitrary text that may be saved alongside content to indicate vehicle by which content was captured, e.g. “post-purchase email”.
@property (assign, nonatomic) NSString * campaignId;


/// Locale to display Labels, Configuration, Product Attributes and Category Attributes in. The default value is the locale defined in the display associated with the API key.
@property (assign, nonatomic) NSString * locale;


/// Boolean indicating whether or not the user wants to be notified when his/her content is published.
@property (assign, nonatomic) BOOL sendEmailAlertWhenPublished;


/// User's email address.
@property (assign, nonatomic) NSString * userEmail;


/// User's external ID.
@property (assign, nonatomic) NSString * userId;


/// User location text.
@property (assign, nonatomic) NSString * userLocation;


/// User nickname display text.
@property (assign, nonatomic) NSString * userNickname;


/**
    This parameter tells the Bazaarvoice platform where to send the email that will contain the authentication link. HostedAuthentication_AuthenticationEmail overrides anything submitted in the 'useremail' field. For further info, please refer to: https://developer.bazaarvoice.com/apis/conversations/tutorials/bazaarvoice_mastered_authentication
 */
@property (assign, nonatomic) NSString *hostedAuthEmail;


/**
    This URL will be used as the front-end to your authentication service. The HostedAuthentication_CallbackURL does not appear in the API response as an available field because it does not represent a user facing question. You should submit this value with no input from content authors. This URL must be white-listed. For further info, please refer to: https://developer.bazaarvoice.com/apis/conversations/tutorials/bazaarvoice_mastered_authentication

 */
@property (assign, nonatomic) NSString *hostedAuthCallbackUrl;


/**
    When using Hosted Authentication to confirm posts with the Conversations API, use the Bazaarvoice-provided User Authentication String to tie the deivce to the user ID so the user can make authenticated POSTs. For further info, please refer to: https://developer.bazaarvoice.com/apis/conversations/tutorials/bazaarvoice_mastered_authentication

 */
@property (assign, nonatomic) NSString *authenticatedUser;


/*!
    Sets ContextDataValue for a particular dimensionExternalId. In general, this parameter is used for custom parameters that a client may want to track.  Some examples of this parameter include the following:
 
    - dimensionExternalId:PurchaserRank value:"top10" -> ContextDataValue_PurchaserRank=top10
    - dimensionExternalId:Purchaser value:"yes" -> ContextDataValue_Purchaser=yes
    - dimensionExternalId:Age value:"35to44" -> ContextDataValue_Age=35to44
    - dimensionExternalId:Gender value:"male" -> ContextDataValue_Gender=male
    @param dimensionExternalId Custom parameter the client wishes to track.
    @param value Value for the custom parameter.
 */
- (void)setContextDataValue:(NSString *)dimensionExternalId value:(NSString *)value;


/*!
    Associates a photo url and corresponding caption with this submission.
    @param url Bazaarvoice URL of a photo uploaded using the Data API.
    @param caption Assocated caption.  May be nil.
 */
- (void)addPhotoUrl:(NSString *)url withCaption:(NSString *)caption;


/*!
    Value is non-negative integer representing the product external ID of the <index>'th product recommendation (for Social Recommendations)
    @param index Index of product recommendation
    @param productExternalId Product external ID for this product recommendation.
 */
- (void)addProductRecommendationForIndex:(int)index withProductExternalId:(int)productExternalId;


/*!
    Associates a video url and corresponding caption with this submission.
    @param url A valid YouTube or Bazaarvoice video-upload URL.
    @param caption Assocated caption.  May be nil.
 */
- (void)addVideoUrl:(NSString *)url withCaption:(NSString *)caption;


/***** Used by Review, Question, Answer, Story *******/


/*!
    Sets AdditionalField for a particular dimensionExternalId.  In general, this parameter is used to attach additional information to a submission.  A concrete example of the parameter might be a dimensionExternalId of'Seat' with a value of '24F' (describing the seat number at a stadium or on a plane) resulting in a parameter AdditionalField_Seat=24F.
    @param dimensionExternalId Name of the additional parameter the client wishes to associate with this submission.
    @param value Value for the additional parameter.
 */
- (void)setAdditionalField:(NSString *)dimensionExternalId value:(NSString *)value;


/***** Used by Review, Question, Story *******/


/// The id of the product that this content is being submitted on.
@property (assign, nonatomic) NSString * productId;


/*!
    Adds a tag with a particular dimensionExternalId and value.  For example, a client might add the value "comfort" for the dimensionExternalId of "Pro" and "expensive" with a dimensionExternalId of "Con."
    @param dimensionExternalId Dimension external id for this tag.
    @param value Tag value.
 */
- (void)addTagForDimensionExternalId:(NSString *)dimensionExternalId value:(NSString *)value;


/*!
    Adds a tagid field with a particular dimensionExternalId and value.  This corresponds to a checkbox in a form.  For example, a client might add the value true for the dimensionExternalId of "Pro/comfort" and true with a dimensionExternalId of "Con/expensive"
    @param dimensionExternalId Dimension external id for this tag.
    @param value Boolean value for this tagid.
 */
- (void)addTagIdForDimensionExternalId:(NSString *)dimensionExternalId value:(BOOL)value;


/***** Used by Review, Story, Comment *******/


/// Content title text.
@property (assign, nonatomic) NSString * title;


/***** Used by Question, Story *******/


/// The id of the category that this content is being submitted on.
@property (assign, nonatomic) NSString * categoryId;


/***** Used by Review *******/


/// Boolean answer to "I would recommend this to a friend".  Required dependent on client settings.
@property (assign, nonatomic) BOOL isRecommended;


/// Text representing a user comment to explain numerical Net Promoter score.
@property (assign, nonatomic) NSString * netPromoterComment;


/// Value is positive integer between 1 and 10 representing a numerical rating in response to “How would you rate this company?”
@property (assign, nonatomic) int netPromoterScore;


/// Value is positive integer between 1 and 5, and represents review overall rating.  Required depending on client settings.
@property (assign, nonatomic) int rating;


/// Contains the text of an review for a BVPostTypeReview request.
@property (assign, nonatomic) NSString * reviewText;


/*!
    Sets a rating for a particular dimensionExternalId.  A concrete example might be a dimensionExternalId of "Quality" where the value would represent the user's opinion of the quality of the product.
    @param dimensionExternalId Custom parameter the client wishes to track.
    @param value A positive integer between 1 and 5 representing rating dimension value.
 */
- (void)setRatingForDimensionExternalId:(NSString *)dimensionExternalId value:(int)value;


/***** Used by Question *******/


/// Indicates whether this submission should be displayed anonymously.
@property (assign, nonatomic) BOOL isUserAnonymous;


/// Contains the text of the question summary for a BVPostTypeQuestion request. Only a single line of text is allowed.
@property (assign, nonatomic) NSString * questionSummary;


/// Contains the text of the question details for a BVPostTypeQuestion request. Multiple lines of text are allowed.
@property (assign, nonatomic) NSString * questionDetails;


/***** Used by Answer *******/


/// Contains the text of an answer for a BVPostTypeAnswer request.
@property (assign, nonatomic) NSString * answerText;


/// The id of the category that this content is being submitted on for a BVPostTypeQuestion request. For such a request, one of productId or categoryId must be provided.
@property (assign, nonatomic) NSString * questionId;


/***** Used by Story *******/


/// Boolean indicating whether or not the user wants to be notified when a comment is posted on the content.
@property (assign, nonatomic) BOOL sendEmailAlertWhenCommented;


/// The text of the story for a BVPostTypeStory request.
@property (assign, nonatomic) NSString * storyText;


/***** Used by Comment *******/


/// The id of the review that this comment is being submitted on for a BVPostTypeReviewComment request.  This field is required for BVPostTypeReviewComment requests.
@property (assign, nonatomic) NSString * reviewId;


/// The id of the story that this comment is being submitted on for a BVPostTypeStoryComment request. This field is required for BVPostTypeStoryComment requests.
@property (assign, nonatomic) NSString * storyId;


/// The text of the comment.
@property (assign, nonatomic) NSString * commentText;


/***** Used by Feedback *******/


/// ID of the content with which a BVPostTypeFeedback request is associated.
@property (assign, nonatomic) NSString * contentId;


/// Type of content with which a BVPostTypeFeedback request is associated. (BVFeedbackContentTypeAnswer, BVFeedbackContentTypeQuestion, BVFeedbackContentTypeReview, BVFeedbackContentTypeReviewComment, BVFeedbackContentTypeStory, BVFeedbackContentTypeStoryComment)
@property (assign, nonatomic) BVFeedbackContentType contentType;


/// Type of feedback for a BVPostTypeFeedback request. (BVFeedbackTypeInappropriate, BVFeedbackTypeHelpfulness)
@property (assign, nonatomic) BVFeedbackType feedbackType;


/// For BVPostTypeFeedback requests.  Reason this content has been flagged as inappropriate.
@property (assign, nonatomic) NSString * reasonText;


/// Helpfulness vote for this content. Valid votes are: BVFeedbackVoteTypePositive, NegatBVFeedbackVoteTypeNegative. This parameter is only required for feedbackType=BVFeedbackTypeHelpfulness.
@property (assign, nonatomic) BVFeedbackVoteType vote;


///  Mass advertising campaigns, trolling, and attempts at automated content submission are all sources of inauthentic content. To combat them Bazaarvoice has partnered with iovation, an industry leader in device reputation technology. Use this parameter to add the fingerPrint parameter to each POST request.
@property (assign, nonatomic) NSString *fingerPrint;


/*!
    Adds a generic parameter to the request.  This method should be used as a last resort when another method does not exist for a particular request you would like to make.  Behavior may be undefined.
    @param name of parameter.
    @param value of parameter.
 */
- (void)addGenericParameterWithName:(NSString *)name value:(NSString *)value;


/// Returns the URL that this request was sent to.  Is only available after the request has been sent.
- (NSString *)requestURL;


/// Sends request asynchronously.  A delegate must be set before this method is called.
- (void) send;


/*!
    Convenience method to set delegate and send request asynchronously.
    @param delegate  The client delegate to receive BVDelegate notifications.
 */
- (void) sendRequestWithDelegate:(id<BVDelegate>)delegate;


@end
