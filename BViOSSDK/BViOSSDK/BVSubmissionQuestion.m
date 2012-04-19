//
//  BVSubmissionQuestion.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/4/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionQuestion.h"

@implementation BVSubmissionQuestion
@synthesize parameters = _parameters;

#pragma mark Overrides
- (NSString*) displayType {
    return @"submitquestion";
}

- (NSString*) contentType {
    return @"Question";
}

#pragma mark Methods
- (BVParameters*) parameters {
    // Lazy instationation...
    if (_parameters == nil) 
        _parameters = [[BVSubmissionParametersQuestion alloc] init];
    return _parameters;
}

@end