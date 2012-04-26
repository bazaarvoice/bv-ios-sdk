//
//  BVSubmissionParametersVideo.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/9/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

@interface BVSubmissionParametersVideo : BVSubmissionParametersBase

@property (nonatomic, copy) NSString* contentType;
@property (nonatomic, strong) NSString* video; // For video linking...

@end
