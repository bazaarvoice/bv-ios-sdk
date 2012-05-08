//
//  BVSubmissionQuestion.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/4/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersQuestion.h"

/*!
 Request class for question submission
 
 See http://developer.bazaarvoice.com/api/5/1/question-submission
 */

@interface BVSubmissionQuestion : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersQuestion* parameters;

@end