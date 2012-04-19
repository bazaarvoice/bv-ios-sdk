//
//  BVSubmissionComment.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionReviewComment.h"

@implementation BVSubmissionReviewComment
@synthesize parameters = _parameters;

#pragma mark Overrides
- (NSString*) displayType {
    return @"submitreviewcomment";
}

- (NSString*) contentType {
    return @"Comment";
}

#pragma mark Methods
- (BVParameters*) parameters {
    // Lazy instationation...
    if (_parameters == nil) 
        _parameters = [[BVSubmissionParametersComment alloc] init];
    return _parameters;
}

@end