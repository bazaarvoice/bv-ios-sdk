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
        
        SET_IF_NOT_NULL(self.positive, apiResponse[@"positive"])
        SET_IF_NOT_NULL(self.negative, apiResponse[@"negative"])

        if (!self.positive) {
            //self.positive =
        }
        
        if (!self.negative) {
            
        }
    }
    return self;
}

@end
