//
//  BVSubmissionPhoto.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/4/12.
//  Copyright (c) 2012 by Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmissionParametersPhoto.h"

@interface BVSubmissionPhoto : BVSubmission

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
@property (nonatomic, strong) BVSubmissionParametersPhoto* parameters;

@end