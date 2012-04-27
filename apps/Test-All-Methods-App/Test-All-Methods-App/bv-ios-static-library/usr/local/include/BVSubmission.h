//
//  BVSubmission.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/27/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSettings.h"
#import "BVBase.h"
#import "BVParameters.h"
#import "BVSubmissionParametersBase.h"

// Derive from BVDisplay, submission request is similar to display request
@interface BVSubmission : BVBase

@property (nonatomic, strong) BVSubmissionParametersBase* parameters;

@end