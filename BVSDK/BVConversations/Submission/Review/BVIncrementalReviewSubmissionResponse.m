//
//  BVIncrementalReviewSubmissionResponse.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVIncrementalReviewSubmissionResponse.h"

@implementation BVIncrementalReviewSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
    if ((self = [super initWithApiResponse:apiResponse])) {
        self.result =
        [[BVSubmittedIncrementalReview alloc] initWithApiResponse:apiResponse[@"response"]];
    }
    return self;
}

@end
