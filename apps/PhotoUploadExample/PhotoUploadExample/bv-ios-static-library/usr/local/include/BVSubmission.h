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

/*! 
 BVSubmission is the base class for all BVSubmission* classes. Subclasses override the parameters property as appropriate.
 */

@interface BVSubmission : BVBase

/*!
 Parameters which are submitted as part of this request.
 */
@property (nonatomic, strong) BVSubmissionParametersBase* parameters;

@end