//
//  BVReviewSubmissionResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewSubmissionResponse.h"

@implementation BVReviewSubmissionResponse

-(nonnull instancetype)initWithApiResponse:(NSDictionary*)apiResponse {
    
    self = [super initWithApiResponse:apiResponse];
    
    if(self){
        self.review = [[BVSubmittedReview alloc] initWithApiResponse:apiResponse[@"Review"]];
    }
    
    return self;
}


@end
