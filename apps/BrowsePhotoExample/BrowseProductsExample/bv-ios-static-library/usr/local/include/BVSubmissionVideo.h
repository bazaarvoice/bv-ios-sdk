//
//  BVSubmissionVideo.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/9/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersVideo.h"

/*!
 Request class for video submission
 
 See http://developer.bazaarvoice.com/api/5/2/video-submission
 */

@interface BVSubmissionVideo : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersVideo* parameters;

@end