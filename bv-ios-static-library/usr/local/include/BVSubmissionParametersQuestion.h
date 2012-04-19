//
//  BVSubmissionParametersQuestion.h
//  bazaarvoiceSDK
//
//  Created by Leon Fu on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

@interface BVSubmissionParametersQuestion : BVSubmissionParametersBase

@property (nonatomic, copy) NSString* questionSummary;
@property (nonatomic, copy) NSString* categoryId;
@property (nonatomic, copy) NSString* questionDetails;

@end