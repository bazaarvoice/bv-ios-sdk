//
//  BVSubmissionParametersVideo.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/9/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersVideo.h"

@implementation BVSubmissionParametersVideo

@synthesize contentType =   _contentType;
@synthesize video       =   _video;

- (NSDictionary*) dictionaryOfValues {
    // Take the dictionary of the base, and add our own parameters
    NSDictionary *returnDictionary;
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryOfValues]];
    [baseDict addEntriesFromDictionary:[self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"contentType", @"video", nil]]];
    
    returnDictionary = [NSDictionary dictionaryWithDictionary:baseDict]; // Return with the additional values.
    returnDictionary = [returnDictionary removeNullValueKeys];
    
    return returnDictionary;
}

@end