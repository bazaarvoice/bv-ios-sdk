//
//  BVSubmissionParametersComment.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

/*!
 BVSubmissionParamatersBase subclass specifically for use with BVSubmissionReviewComment requests.
 */

@interface BVSubmissionParametersComment : BVSubmissionParametersBase

/*!
 The text of the comment.
 */
@property (nonatomic, copy) NSString* commentText;
/*!
 The id of the review that this comment is being submitted on.  One of ReviewId or StoryId is required.
 */
@property (nonatomic, copy) NSString* reviewId;
/*!
 The id of the story that this comment is being submitted on.  One of ReviewId or StoryId is required.
 */
@property (nonatomic, copy) NSString* storyId;
/*!
 Title text
 */
@property (nonatomic, copy) NSString* title;

@end