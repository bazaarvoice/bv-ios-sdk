//
//  BVSubmissionParametersVideo.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/9/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

/*!
 BVSubmissionParamatersBase subclass specifically for use with BVSubmissionVideo requests.
 */
@interface BVSubmissionParametersVideo : BVSubmissionParametersBase

@property (nonatomic, copy) NSString* contentType;
/*!
 Video for linking
 */
@property (nonatomic, strong) NSString* video;

@end
