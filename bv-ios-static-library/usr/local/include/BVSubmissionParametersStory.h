//
//  BVSubmissionParametersStory.h
//  bazaarvoiceSDK
//
//  Created by Leon Fu on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

@interface BVSubmissionParametersStory : BVSubmissionParametersBase

@property (nonatomic, copy) NSString* categoryId;
@property (nonatomic, copy) NSString* sendEmailAlertWhenCommented;
@property (nonatomic, copy) NSString* storyText;
@property (nonatomic, copy) NSString* title;

@end