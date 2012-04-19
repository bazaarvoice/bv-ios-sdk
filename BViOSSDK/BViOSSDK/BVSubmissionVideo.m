//
//  BVSubmissionVideo.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/9/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionVideo.h"

@implementation BVSubmissionVideo
@synthesize parameters = _parameters;

#pragma mark Overrides
- (NSString*) displayType {
    return @"uploadvideo";
}

- (NSString*) contentType {
    return self.parameters.contentType; // In this case, the content type is passed as a parameter
}

#pragma mark Methods
- (BVParameters*) parameters {
    // Lazy instationation...
    if (_parameters == nil) 
        _parameters = [[BVSubmissionParametersVideo alloc] init];
    return _parameters;
}

@end