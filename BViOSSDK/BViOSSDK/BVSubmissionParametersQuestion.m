//
//  BVSubmissionParametersQuestion.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/4/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersQuestion.h"

@implementation BVSubmissionParametersQuestion

@synthesize questionSummary                     = _questionSummary;
@synthesize categoryId                          = _categoryId;
@synthesize questionDetails                     = _questionDetails;

- (NSDictionary*) dictionaryOfValues {
    // Take the dictionary of the base, and add our own parameters
    NSDictionary *returnDictionary;
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryOfValues]];
    [baseDict addEntriesFromDictionary:[self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"questionSummary"
                                                                          , @"categoryId", @"questionDetails", nil]]];
    
    returnDictionary = [NSDictionary dictionaryWithDictionary:baseDict]; // Return with the BVParams.
    returnDictionary = [returnDictionary removeNullValueKeys];
    
    return returnDictionary;
}

@end