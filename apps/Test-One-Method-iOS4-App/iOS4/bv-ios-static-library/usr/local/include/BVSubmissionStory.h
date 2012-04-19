//
//  BVSubmissionStory.h
//  bazaarvoiceSDK
//
//  Created by Leon Fu on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersStory.h"

@interface BVSubmissionStory : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersStory* parameters;

@end