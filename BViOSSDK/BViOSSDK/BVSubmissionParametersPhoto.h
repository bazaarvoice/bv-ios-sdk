//
//  BVSubmissionParametersPhoto.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/4/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import <UIKIt/UIImage.h>
#import "BVSubmissionParametersBase.h"

@interface BVSubmissionParametersPhoto : BVSubmissionParametersBase

@property (nonatomic, copy) NSString* contentType;
@property (nonatomic, strong) UIImage* photo;

@end
