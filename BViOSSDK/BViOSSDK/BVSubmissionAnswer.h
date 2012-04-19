//
//  BVSubmissionAnswer.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersAnswer.h"

@interface BVSubmissionAnswer : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersAnswer* parameters;

@end