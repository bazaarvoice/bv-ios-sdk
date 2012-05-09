//
//  BVSubmissionParametersStory.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

/*!
 BVSubmissionParamatersBase subclass specifically for use with BVSubmissionStory requests.
 */

@interface BVSubmissionParametersStory : BVSubmissionParametersBase

/*!
 The id of the category that this content is being submitted on.
 */
@property (nonatomic, copy) NSString* categoryId;
/*!
 Boolean indicating whether or not the user wants to be notified when a comment is posted on the content
 */
@property (nonatomic, copy) NSString* sendEmailAlertWhenCommented;
/*!
 The text of the story.
 */
@property (nonatomic, copy) NSString* storyText;
/*!
 The title of the story.
 */
@property (nonatomic, copy) NSString* title;

@end