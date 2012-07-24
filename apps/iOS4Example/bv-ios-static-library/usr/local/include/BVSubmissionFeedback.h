//
//  BVSubmissionFeedback.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 7/24/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersFeedback.h"

/*!
 Request class for feedback submission
 
 See http://developer.bazaarvoice.com/api/5/2/feedback-submission
 */

@interface BVSubmissionFeedback : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersFeedback* parameters;

@end
