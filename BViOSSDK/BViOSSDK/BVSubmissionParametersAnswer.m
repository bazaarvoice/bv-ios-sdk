//
//  BVSubmissionParametersAnswer.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersAnswer.h"

@implementation BVSubmissionParametersAnswer

@synthesize answerText              = _answerText;
@synthesize questionId              = _questionId;

- (NSDictionary*) dictionaryOfValues {
    // Take the dictionary of the base, and add our own parameters
    NSDictionary *returnDictionary;
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryOfValues]];
    [baseDict addEntriesFromDictionary:[self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"answerText"
                                                                          , @"questionId", nil]]];
    
    returnDictionary = [NSDictionary dictionaryWithDictionary:baseDict]; // Return with the BVParams.
    returnDictionary = [returnDictionary removeNullValueKeys];
    
    return returnDictionary;
}

@end