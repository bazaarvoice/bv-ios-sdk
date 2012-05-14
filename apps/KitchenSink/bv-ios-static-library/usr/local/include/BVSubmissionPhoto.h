//
//  BVSubmissionPhoto.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/4/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersPhoto.h"

/*!
 Request class for photo submission
 
 See http://developer.bazaarvoice.com/api/5/1/photo-submission
 */


@interface BVSubmissionPhoto : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersPhoto* parameters;

@end