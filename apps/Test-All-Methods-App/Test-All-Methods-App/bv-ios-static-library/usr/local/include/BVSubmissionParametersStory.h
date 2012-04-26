//
//  BVSubmissionParametersStory.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

@interface BVSubmissionParametersStory : BVSubmissionParametersBase

@property (nonatomic, copy) NSString* categoryId;
@property (nonatomic, copy) NSString* sendEmailAlertWhenCommented;
@property (nonatomic, copy) NSString* storyText;
@property (nonatomic, copy) NSString* title;

@end