//
//  BVSubmissionParametersPhoto.h
//  bazaarvoiceSDK
//
//  Created by Leon Fu on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKIt/UIImage.h>
#import "BVSubmissionParametersBase.h"

@interface BVSubmissionParametersPhoto : BVSubmissionParametersBase

@property (nonatomic, copy) NSString* contentType;
@property (nonatomic, strong) UIImage* photo;

@end
