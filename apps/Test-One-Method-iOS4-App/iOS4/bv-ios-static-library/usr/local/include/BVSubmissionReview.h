//
//  BVSubmissionReview.h
//  bazaarvoiceSDK
//
//  Created by Leon Fu on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersReview.h"

@interface BVSubmissionReview : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersReview* parameters;

@end