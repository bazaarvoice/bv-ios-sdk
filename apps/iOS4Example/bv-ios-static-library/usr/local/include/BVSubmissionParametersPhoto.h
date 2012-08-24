//
//  BVSubmissionParametersPhoto.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/4/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIImage.h>
#import "BVSubmissionParametersBase.h"

/*!
 BVSubmissionParamatersBase subclass specifically for use with BVSubmissionPhoto requests.
 */

@interface BVSubmissionParametersPhoto : BVSubmissionParametersBase

@property (nonatomic, copy) NSString* contentType;
/*!
 A UIImage representing the photo to be submitted.
 */
@property (nonatomic, strong) UIImage* photo;

@end
