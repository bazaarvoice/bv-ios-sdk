//
//  BVSubmissionParametersQuestion.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/4/12.
//  Copyright (c) 2012 by Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

@interface BVSubmissionParametersQuestion : BVSubmissionParametersBase

@property (nonatomic, copy) NSString* questionSummary;
@property (nonatomic, copy) NSString* categoryId;
@property (nonatomic, copy) NSString* questionDetails;

@end