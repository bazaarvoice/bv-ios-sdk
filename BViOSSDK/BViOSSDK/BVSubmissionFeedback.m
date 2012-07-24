//
//  BVSubmissionFeedback.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 7/24/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionFeedback.h"

@implementation BVSubmissionFeedback
@synthesize parameters = _parameters;

#pragma mark Overrides
- (NSString*) displayType {
    return @"submitfeedback";
}

- (NSString*) contentType {
    return self.parameters.contentType; // In this case, the content type is passed as a parameter
}

#pragma mark Methods
- (BVParameters*) parameters {
    // Lazy instationation...
    if (_parameters == nil) 
        _parameters = [[BVSubmissionParametersFeedback alloc] init];
    return _parameters;
}

@end