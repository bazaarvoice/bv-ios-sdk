//
//  BVSubmissionComment.h
//  bazaarvoiceSDK
//
//  Created by Leon Fu on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersComment.h"

@interface BVSubmissionReviewComment : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersComment* parameters;

@end