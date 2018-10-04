//
//  BVReviewSubmission.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBaseUGCSubmission.h"
#import "BVSubmittedReview.h"

/**
 Class to use to submit a review to the Bazaarvoice platform.

 Of the many parameters possible on a BVReviewSubmission, the ones needed for
 submission depend on your specific implementation.

 For a description of possible fields see our API documentation at:
 https://developer.bazaarvoice.com/docs/read/conversations/reviews/submit/5_4

 @availability 4.1.0 and later
 */
@interface BVReviewSubmission : BVBaseUGCSubmission <BVSubmittedReview *>

/**
 Create a new BVReviewSubmission.

 @param reviewTitle    The user-provided title of the review.
 @param reviewText     The user-provided body of the review.
 @param rating         The user-provided rating: 1-5.
 @param productId      The productId that this review is associated with.
 */
- (nonnull instancetype)initWithReviewTitle:(nonnull NSString *)reviewTitle
                                 reviewText:(nonnull NSString *)reviewText
                                     rating:(NSUInteger)rating
                                  productId:(nonnull NSString *)productId;
- (nonnull instancetype)__unavailable init;

/// Value is text representing a user comment to explain numerical Net Promoter
/// score.
@property(nullable) NSString *netPromoterComment;

/// Value is positive integer between 1 and 10 representing a numerical rating
/// in response to “How would you rate this company?”
@property(nullable) NSNumber *netPromoterScore;

/// Value is true or false; default is null – "true" or "false" answer to "I
/// would recommend this to a friend". Required dependent on client settings.
@property(nullable) NSNumber *isRecommended;

/// The product id used to filter the review on.
@property(nonnull, readonly) NSString *productId;

- (void)addAdditionalField:(nonnull NSString *)fieldName
                     value:(nonnull NSString *)value;
- (void)addContextDataValueString:(nonnull NSString *)contextDataValueName
                            value:(nonnull NSString *)value;
- (void)addContextDataValueBool:(nonnull NSString *)contextDataValueName
                          value:(bool)value;
- (void)addRatingQuestion:(nonnull NSString *)ratingQuestionName
                    value:(NSInteger)value;
- (void)addRatingSlider:(nonnull NSString *)ratingQuestionName
                  value:(nonnull NSString *)value;
- (void)addPredefinedTagDimension:(nonnull NSString *)tagQuestionId
                            tagId:(nonnull NSString *)tagId
                            value:(nonnull NSString *)value;
- (void)addFreeformTagDimension:(nonnull NSString *)tagQuestionId
                      tagNumber:(NSInteger)tagNumber
                          value:(nonnull NSString *)value;

/**
 Submit a Youtube video link with UGC

 @param url The full URL string of the Youtube video
 @param videoCaption The use-provided caption for the video
*/
- (void)addVideoURL:(nonnull NSString *)url
        withCaption:(nullable NSString *)videoCaption;

@end
