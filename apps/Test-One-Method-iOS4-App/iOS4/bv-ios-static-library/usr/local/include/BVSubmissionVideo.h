//
//  BVSubmissionVideo.h
//  bazaarvoiceSDK
//
//  Created by Leon Fu on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersVideo.h"

@interface BVSubmissionVideo : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersVideo* parameters;

@end