//
//  BVSubmissionReview.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/27/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersReview.h"

/*!
 Request class for review submission
 
 See http://developer.bazaarvoice.com/api/5/1/review-submission
 */

@interface BVSubmissionReview : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersReview* parameters;

@end