//
//  BVSubmissionParametersComment.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/5/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersComment.h"

@implementation BVSubmissionParametersComment

@synthesize commentText                     =   _commentText;
@synthesize reviewId                        =   _reviewId;
@synthesize storyId                         =   _storyId;
@synthesize title                           =   _title;

- (NSDictionary*) dictionaryOfValues {
    // Take the dictionary of the base, and add our own parameters
    NSDictionary *returnDictionary;
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryOfValues]];
    [baseDict addEntriesFromDictionary:[self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"commentText"
                                                                          , @"reviewId", @"storyId", @"title", nil]]];

    
    returnDictionary = [NSDictionary dictionaryWithDictionary:baseDict]; // Return with the BVParams.
    returnDictionary = [returnDictionary removeNullValueKeys];
    
    return returnDictionary;
}

@end