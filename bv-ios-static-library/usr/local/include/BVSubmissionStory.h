//
//  BVSubmissionStory.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersStory.h"

/*!
 Request class for story submission
 
 See http://developer.bazaarvoice.com/api/5/2/story-submission
 */

@interface BVSubmissionStory : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersStory* parameters;

@end