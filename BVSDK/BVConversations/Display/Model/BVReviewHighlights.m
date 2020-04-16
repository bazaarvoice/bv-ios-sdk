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
                
        //Mapping PositiveData
        NSDictionary *positiveData = [apiResponse objectForKey:@"positive"];
        NSMutableArray *positivesArrayBuilder = [NSMutableArray array];
        
        for (NSString *key in positiveData) {
            BVReviewHighlight *positive = [[BVReviewHighlight alloc] initWithTitle:key content:positiveData[key]];
            [positivesArrayBuilder addObject:positive];
        }
        
        // Sort in the descending order of mentionsCount
        [positivesArrayBuilder sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            BVReviewHighlight *firstReviewHighlight = (BVReviewHighlight *) obj1;
            BVReviewHighlight *secondReviewHighlight = (BVReviewHighlight *) obj2;
            return [secondReviewHighlight.mentionsCount compare:firstReviewHighlight.mentionsCount];
            
        }];
        
        self.positives = positivesArrayBuilder;

        
        //Mapping NegativeData
        NSDictionary *negativeData = [apiResponse objectForKey:@"negative"];
        NSMutableArray *negativesArrayBuilder = [NSMutableArray array];
        
        for (NSString *key in negativeData) {
            BVReviewHighlight *negative = [[BVReviewHighlight alloc] initWithTitle:key content:negativeData[key]];
            [negativesArrayBuilder addObject:negative];
        }
        
        // Sort in the descending order of mentionsCount
        [negativesArrayBuilder sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            BVReviewHighlight *firstReviewHighlight = (BVReviewHighlight *) obj1;
            BVReviewHighlight *secondReviewHighlight = (BVReviewHighlight *) obj2;
            return [secondReviewHighlight.mentionsCount compare:firstReviewHighlight.mentionsCount];
            
        }];
        
        self.negatives = negativesArrayBuilder;
    }
    return self;
}

@end
