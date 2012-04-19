//
//  BVSubmissionReview.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/27/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionReview.h"

@implementation BVSubmissionReview
@synthesize parameters = _parameters;

#pragma mark Overrides
- (NSString*) displayType {
    return @"submitreview";
}

- (NSString*) contentType {
    return @"Review";
}

#pragma mark Methods
- (BVParameters*) parameters {
    // Lazy instationation...
    if (_parameters == nil) 
        _parameters = [[BVSubmissionParametersReview alloc] init];
    return _parameters;
}

@end