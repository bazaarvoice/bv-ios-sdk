//
//  BVSubmissionParametersReview.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/27/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

/*!
 BVSubmissionParamatersBase subclass specifically for use with BVSubmissionReview requests.
 */

@interface BVSubmissionParametersReview : BVSubmissionParametersBase

/*!
 Value is content title text.
 */
@property (nonatomic, copy) NSString* title;
/*!
 Value is true or false; default is null – "true" or "false" answer to "I would recommend this to a friend".  Required dependent on client settings.
 */
@property (nonatomic, copy) NSString* isRecommended;
/*!
 Value is text representing a user comment to explain numerical Net Promoter score.
 */
@property (nonatomic, copy) NSString* netPromoterComment;
/*!
 Value is positive integer between 1 and 10 representing a numerical rating in response to “How would you rate this company?”
 */
@property (nonatomic, copy) NSString* netPromoterScore;
/*!
 Value is positive integer between 1 and 5, and represents review overall rating.  Required depending on client settings.
 */
@property (nonatomic, copy) NSString* rating;
/*!
 BVParametersType param for an external rating.
 
 A BVParametersType parameter with:
 
 - prefixName = "Rating"
 - typeName = <Dimension-External-Id>
 - typeValue = A positive integer between 1 and 5 and represents rating dimension value.
 
 A concrete example might be Rating_Quality where the value would represent the user's opinion of the quality of the product. 
 */
@property (nonatomic, strong) BVParametersType* RatingParam;
/*!
 Review body text
 */
@property (nonatomic, copy) NSString* reviewText;

@end
