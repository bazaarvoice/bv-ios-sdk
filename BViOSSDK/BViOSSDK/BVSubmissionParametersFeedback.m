//
//  BVSubmissionParametersFeedback.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 7/24/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersFeedback.h"

@implementation BVSubmissionParametersFeedback
    
@synthesize contentId = _contentId;
@synthesize contentType =   _contentType;
@synthesize feedbackType = _feedbackType;
@synthesize vote = _vote;
@synthesize reasonText = _reasonText;

- (NSDictionary*) dictionaryOfValues {
    // Take the dictionary of the base, and add our own parameters
    NSDictionary *returnDictionary;
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryOfValues]];
    [baseDict addEntriesFromDictionary:[self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"contentId", @"contentType", @"feedbackType", @"vote", @"reasonText", nil]]];
    
    returnDictionary = [NSDictionary dictionaryWithDictionary:baseDict]; // Return with the BVParams.
    returnDictionary = [returnDictionary removeNullValueKeys];
    
    return returnDictionary;
}



@end
