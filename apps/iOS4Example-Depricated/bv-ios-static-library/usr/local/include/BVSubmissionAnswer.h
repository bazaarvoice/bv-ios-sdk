//
//  BVSubmissionAnswer.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersAnswer.h"

/*!
 Request class for answer submission
 
 See http://developer.bazaarvoice.com/api/5/2/answer-submission
 */


@interface BVSubmissionAnswer : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersAnswer* parameters;

@end