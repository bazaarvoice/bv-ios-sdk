//
//  BVSubmissionAnswer.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionAnswer.h"

@implementation BVSubmissionAnswer
@synthesize parameters = _parameters;

#pragma mark Overrides
- (NSString*) displayType {
    return @"submitanswer";
}

- (NSString*) contentType {
    return @"Answer";
}

#pragma mark Methods
- (BVParameters*) parameters {
    // Lazy instationation...
    if (_parameters == nil) 
        _parameters = [[BVSubmissionParametersAnswer alloc] init];
    return _parameters;
}

@end