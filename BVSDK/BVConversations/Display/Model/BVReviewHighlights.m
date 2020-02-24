//
//  BVReviewHighlights.m
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import "BVReviewHighlights.h"
#import "BVNullHelper.h"

@implementation BVReviewHighlights

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
    
    if ((self = [super init])) {
        
        if (!apiResponse || ![apiResponse isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        NSDictionary *apiObject = (NSDictionary *)apiResponse;
        
        //Mapping PositiveData
        NSDictionary *positiveData = [apiResponse objectForKey:@"positive"];
        NSMutableArray *positivesArrayBuilder = [NSMutableArray array];
        
        for (NSString *key in positiveData) {
            BVReviewHighlight *positive = [[BVReviewHighlight alloc] initWithTitle:key content:positiveData[key]];
            [positivesArrayBuilder addObject:positive];
        }
        self.positives = positivesArrayBuilder;

        
        //Mapping NegativeData
        NSDictionary *negativeData = [apiResponse objectForKey:@"negative"];
        NSMutableArray *negativesArrayBuilder = [NSMutableArray array];
        
        for (NSString *key in negativeData) {
            BVReviewHighlight *negative = [[BVReviewHighlight alloc] initWithTitle:key content:negativeData[key]];
        }
        self.negatives = negativesArrayBuilder;
    }
    return self;
}

@end
