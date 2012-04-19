//
//  BVSubmissionParametersReview.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/27/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersReview.h"

@implementation BVSubmissionParametersReview

@synthesize title                                   = _title;
@synthesize isRecommended                           = _isRecommended;
@synthesize netPromoterComment                      = _netPromoterComment;
@synthesize netPromoterScore                        = _netPromoterScore;
@synthesize rating                                  = _rating;
@synthesize RatingParam                             = _RatingParam;
@synthesize reviewText                              = _reviewText;

- (NSDictionary*) dictionaryOfValues {
    // Take the dictionary of the base, and add our own parameters
    NSDictionary *returnDictionary;
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryOfValues]];
    [baseDict addEntriesFromDictionary:[self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"title"
            , @"isRecommended", @"netPromoterComment", @"netPromoterScore", @"rating"
            , @"reviewText", nil]]];
    
    NSMutableDictionary *BVParamDict = [[NSMutableDictionary alloc] init];
    [BVParamDict addEntriesFromDictionary:[self.RatingParam dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:baseDict];
    [BVParamDict addEntriesFromDictionary:returnDictionary];
    
    returnDictionary = [NSDictionary dictionaryWithDictionary:BVParamDict]; // Return with the BVParams.
    returnDictionary = [returnDictionary removeNullValueKeys];
    
    return returnDictionary;
}

// Allocate memory for BVParametersType here.
- (BVParametersType*) RatingParam {
    // Lazy instationation...
    if (_RatingParam == nil) {
        _RatingParam = [[BVParametersType alloc] init];
        _RatingParam.prefixName = @"Rating";
    }
    
    return _RatingParam;
}

@end