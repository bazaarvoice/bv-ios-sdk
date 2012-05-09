//
//  BVSubmissionParametersAnswer.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

/*!
 BVSubmissionParamatersBase subclass specifically for use with BVSubmissionAnswer requests.
 */


@interface BVSubmissionParametersAnswer : BVSubmissionParametersBase

@property (nonatomic, copy) NSString* answerText;
@property (nonatomic, copy) NSString* questionId;

@end