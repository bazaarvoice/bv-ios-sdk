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
        
        SET_IF_NOT_NULL(self.positives, apiResponse[@"positive"])
        SET_IF_NOT_NULL(self.negatives, apiResponse[@"negative"])

        if (!self.positives) {
            //self.positive =
        }
        
        if (!self.negatives) {
            
        }
    }
    return self;
}

@end
