//
//  BVSubmissionParametersStory.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersStory.h"

@implementation BVSubmissionParametersStory

@synthesize categoryId                      = _categoryId;
@synthesize sendEmailAlertWhenCommented     = _sendEmailAlertWhenCommented;
@synthesize storyText                       = _storyText;
@synthesize title                           = _title;

- (NSDictionary*) dictionaryOfValues {
    // Take the dictionary of the base, and add our own parameters
    NSDictionary *returnDictionary;
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryOfValues]];
    [baseDict addEntriesFromDictionary:[self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"categoryId"
                                                                          , @"sendEmailAlertWhenCommented", @"storyText"
                                                                          , @"title", nil]]];
    
    returnDictionary = [NSDictionary dictionaryWithDictionary:baseDict]; // Return with the BVParams.
    returnDictionary = [returnDictionary removeNullValueKeys];
    
    return returnDictionary;
}

@end