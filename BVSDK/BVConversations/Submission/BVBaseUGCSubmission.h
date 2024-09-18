//
//  BVBaseUGCSubmission.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionAction.h"
#import "BVSubmissionResponse.h"
#import "BVSubmittedType.h"

@class UIImage;

/// Base class used for defining common properties for a UGC content types of
/// the Conversations API: Reviews, Review Comments, Questions and Answers.
@interface BVBaseUGCSubmission <__covariant BVResponseType : BVSubmittedType *> : BVSubmission<BVResponseType>

/// Set whether or not to to perform a preview on the submission or submit for
/// real. Default is BVSubmissionActionPreview. A preview is like a dry run, but
/// validation of the fields will occur through the API call over the network
/// but no data will be submitted.
/// - Note:
/// \
/// If the `action` of this object is set to `BVSubmissionActionPreview` then
/// the submission will NOT actually take place.

@property BVSubmissionAction action;

/// Value of the encrypted user. This parameter demonstrates that a user has
/// been authenticated. Note that the UserId parameter does not contain
/// authentication information and should not be used for hosted authentication.
/// See the Authenticate User method for more information.
@property(nullable) NSString *user;

/// User's email address
@property(nullable) NSString *userEmail;

/// User's external ID. Do not use email addresses for this value.
@property(nullable) NSString *userId;

/// User location text
@property(nullable) NSString *userLocation;

/// User nickname display text
@property(nullable) NSString *userNickname;

/// Boolean indicating whether or not the user agreed to the terms and
/// conditions. Required depending on the client's settings.
@property(nullable) NSNumber *agreedToTermsAndConditions;

/// Boolean indicating whether or not the user wants to be notified when a
/// comment is posted on the content.
@property(nullable) NSNumber *sendEmailAlertWhenCommented;

/// Boolean indicating whether or not the user wants to be notified when his/her
/// content is published.
@property(nullable) NSNumber *sendEmailAlertWhenPublished;

/// Locale to display Labels, Configuration, Product Attributes and Category
/// Attributes in. The default value is the locale defined in the display
/// associated with the API key.
@property(nullable) NSString *locale;

/// Arbitrary text that may be saved alongside content to indicate vehicle by
/// which content was captured, e.g. “post-purchase email”.
@property(nullable) NSString *campaignId;

/// Email address where the submitter will receive the confirmation email. If
/// you are configured to use hosted email authentication, this parameter is
/// required. See the Authenticate User method for more information on hosted
/// authentication.
@property(nullable) NSString *hostedAuthenticationEmail;

/// URL of the link contained in the user authentication email. This should
/// point to a landing page where a web application exists to complete the user
/// authentication process. The host for the URL must be one of the domains
/// configured for the client. The link in the email will contain a user
/// authentication token (authtoken) that is used to verify the submitter. If
/// you are configured to use hosted email authentication, this parameter is
/// required. See the hosted authentication tutorial for more information.
@property(nullable) NSString *hostedAuthenticationCallback;

/// Fingerprint of content author's device. See the Authenticity Tutorial for
/// more information.
///
/// Per the Bazaarvoice Authenticity Policy, you must send a device fingerprint
/// attached to each submission. If you fail to send a device fingerprint with
/// your submission, Bazaarvoice may take any action deemed necessary in
/// Bazaarvoice’s sole discretion to protect the integrity of the network. Such
/// actions may include but are not limited to: rejection of your content,
/// halting syndication of your content on the Bazaarvoice network, revocation
/// of your API key, or revocation of your API license.
@property(nullable) NSString *fingerPrint;

/// Add a user-provided photo.
///
/// @param image           The user-provded image.
/// @param photoCaption    The user-provided caption for the photo.
- (void)addPhoto:(nonnull UIImage *)image
    withPhotoCaption:(nullable NSString *)photoCaption;

/// Add a user-provided video.
///
/// @param videoPath           The user-provded video.
/// @param videoCaption    The user-provided caption for the video.
- (void)addVideo:(nonnull NSURL *)videoPath
    withVideoCaption:(nullable NSString *)videoCaption
    uploadVideo:(BOOL)uploadVideo;

@end
