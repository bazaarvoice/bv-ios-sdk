//
//  BVSubmissionParametersAnswer.h
//  bazaarvoiceSDK
//
//  Created by Leon Fu on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

@interface BVSubmissionParametersAnswer : BVSubmissionParametersBase

@property (nonatomic, copy) NSString* answerText;
@property (nonatomic, copy) NSString* questionId;

@end