//
//  BVSubmissionParametersFeedback.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 7/24/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

/*!
 BVSubmissionParamatersBase subclass specifically for use with BVSubmissionFeedback requests.
 */
@interface BVSubmissionParametersFeedback : BVSubmissionParametersBase

/*!
 Type of content with which the feedback is associated (review, story, question, answer, or comment)
 */
@property (nonatomic, copy) NSString* contentType;
/*!
 ID of the content with which the feedback is associated
 */
@property (nonatomic, copy) NSString* contentId;
/*!
 The type of feedback.  Valid values are "inappropriate" and "helpfulness".
 */
@property (nonatomic, copy) NSString* feedbackType;
/*!
 Helpfulness vote for this content. Valid votes are: Positive, Negative. This parameter is only required for feedbackType=helpfulness.
 */
@property (nonatomic, copy) NSString* vote;
/*!
 Reason this content has been flagged as inappropriate
 */
@property (nonatomic, copy) NSString* reasonText;

@end
