//
//  BVReviewHighlightsReview.m
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import "BVReviewHighlightsReview.h"
#import "BVNullHelper.h"

@implementation BVReviewHighlightsReview

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
    
    if ((self = [super init])) {
        
        if (!apiResponse || ![apiResponse isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        NSDictionary *apiObject = (NSDictionary *)apiResponse;
        
        SET_IF_NOT_NULL(self.rating, apiObject[@"rating"])
        SET_IF_NOT_NULL(self.about, apiObject[@"about"])
        SET_IF_NOT_NULL(self.reviewText, apiObject[@"reviewText"])
        SET_IF_NOT_NULL(self.author, apiObject[@"author"])
        SET_IF_NOT_NULL(self.snippetId, apiObject[@"snippetId"])
        SET_IF_NOT_NULL(self.reviewId, apiObject[@"reviewId"])
        SET_IF_NOT_NULL(self.summary, apiObject[@"summary"])
        SET_IF_NOT_NULL(self.submissionTime, apiObject[@"submissionTime"])
        SET_IF_NOT_NULL(self.reviewTitle, apiObject[@"reviewTitle"])
        
        if (!self.rating) {
            self.rating = [NSNumber numberWithInt:0];
        }

    }
    return self;
}

@end
