//
//  BVSubmissionParametersBase.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/27/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVParameters.h"

@interface NSDictionary (removeNullKeys)
- (NSDictionary*) removeNullValueKeys;
@end

/*!
 Base class for all BVSubmissionParameters* classes and encapsulates all parameters which are common to BVSubmission* requests.  This class should not be used directly, but the specific subclass should be used for the appropriate request type.  For instance, a BVSubmissionParametersAnswer should be used when making a request with BVSubmissionAnswer.
 */
@interface BVSubmissionParametersBase : BVParameters

/*!
 The submission action to take -- either 'Preview' or 'Submit'.  'Preview' will show a draft of the content to be submitted; 'Submit' will submit the content.
 */
@property (nonatomic, copy) NSString* action;
/*!
 The id of the product that this content is being submitted on.
 */
@property (nonatomic, copy) NSString* productId;
/*!
 A concrete example of this parameter might be 'AdditionalField_Seat' with a value of '24F' (describing the seat number at a stadium or on a plane).
 */
@property (nonatomic, strong) BVParametersType* additionalField;
/*!
 Boolean indicating whether or not the user agreed to the terms and conditions.  Required depending on the client's settings.
 */
@property (nonatomic, copy) NSString* agreedToTermsAndConditions;
/*!
 Arbitrary text that may be saved alongside content to indicate vehicle by which content was captured, e.g. “post-purchase email”.
 */
@property (nonatomic, copy) NSString* campaignId;
/*!
 Some examples of this parameter include the following. Each is followed by possible values.
 
 - ContextDataValue_PurchaserRank - "top", "top10", "top100", "top1000"
 - ContextDataValue_Purchaser - "yes", "no"
 - ContextDataValue_Age - "under21", "21to34", "35to44", "45to54", "55to64", "over65"
 - ContextDataValue_Gender - "male", "female"
 */
@property (nonatomic, strong) BVParametersType* contextDataValue;
@property (nonatomic, copy) NSString* isUserAnonymous;

/*!
 Locale to display Labels, Configuration, Product Attributes and Category Attributes in. The default value is the locale defined in the display associated with the API key. If specified, the locale value is also used as the default ContentLocale filter value.
 */
@property (nonatomic, copy) NSString* locale;
/*!
 A BVParametersType parameter with:
 - prefixName = "PhotoCaption"
 - typeName = <n>
 - typeValue = Caption text for the photo URL with the same value of <n>.
*/
@property (nonatomic, strong) BVParametersType* photoCaption;
/*!
 A BVParametersType parameter with:
 - prefixName = "PhotoUrl"
 - typeName = <n>
 - typeValue = A Bazaarvoice URL of a photo uploaded using the Data API, where <n> is a non-negative integer.
 */
@property (nonatomic, strong) BVParametersType* photoURL;
/*!
 A BVParametersType parameter with:
 - prefixName = "ProductRecommendationId"
 - typeName = <n>
 - typeValue = A non-negative integer representing the product external ID of the <n>'th product recommendation (for Social Recommendations)
 */
@property (nonatomic, strong) BVParametersType* productRecommendationId;
/*!
 Boolean indicating whether or not the user wants to be notified when his/her content is published.
 */
@property (nonatomic, copy) NSString* sendEmailAlertWhenPublished;
/*!
 A BVParametersType parameter with:
 - prefixName = "tag"
 - typeName = A parameter of the form <Dimension-External-Id>_<n>. <n> should be a non-negative integer starting at the number 1.  A concrete example of this parameter might be 'Pro_1'.
 - typeValue = Any free form text tag.
 */
@property (nonatomic, strong) BVParametersType* tag;
/*!
 User's email address.
 */
@property (nonatomic, copy) NSString* userEmail;
/*!
 User's external ID.
 */
@property (nonatomic, copy) NSString* userId;
/*!
 User location text
 */
@property (nonatomic, copy) NSString* userLocation;
/*!
 User nickname display text.
 */
@property (nonatomic, copy) NSString* userNickName;
/*!
 A BVParametersType parameter with:
 - prefixName = "VideoCaption"
 - typeName = <n>
 - typeValue = Caption text for the video URL with the same value of <n>.
 */

@property (nonatomic, strong) BVParametersType* videoCaption;
/*!
 A BVParametersType parameter with:
 - prefixName = "VideoUrl"
 - typeName = <n>
 - typeValue = Value is valid YouTube or Bazaarvoice video-upload URL where <n> is a non-negative integer.
 */
@property (nonatomic, strong) BVParametersType* videoUrl;

// Get a dictionary of values that were set.
@property (nonatomic, readonly) NSDictionary* dictionaryOfValues;

@end