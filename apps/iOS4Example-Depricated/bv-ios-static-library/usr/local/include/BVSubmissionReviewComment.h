//
//  BVSubmissionComment.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersComment.h"

/*!
 Request class for review comment submission
 
 See http://developer.bazaarvoice.com/api/5/2/comment-submission
 */

@interface BVSubmissionReviewComment : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersComment* parameters;

@end