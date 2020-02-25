//
//  BVReviewHighlightsResponse.m
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import "BVReviewHighlightsResponse.h"

@implementation BVReviewHighlightsResponse

- (instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
    if ((self = [super init])) {
        
        self.reviewHighlights = [[BVReviewHighlights alloc] initWithApiResponse:[apiResponse objectForKey:@"subjects"]];
        
    }
    return self;
}

@end
