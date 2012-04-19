//
//  BVSubmissionQuestion.h
//  bazaarvoiceSDK
//
//  Created by Leon Fu on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersQuestion.h"

@interface BVSubmissionQuestion : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersQuestion* parameters;

@end