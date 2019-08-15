//
//  BVMultiProductSubmissionErrorResponse.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVMultiProductSubmissionErrorResponse.h"
#import "BVNullHelper.h"


@implementation BVMultiProductSubmissionErrorResponse

- (instancetype)initWithApiResponse:(nullable id)apiResponse {
    if ((self = [super initWithApiResponse:apiResponse])) {
        if (__IS_KIND_OF(apiResponse, NSDictionary)) {
            NSDictionary *apiObject = (NSDictionary *)apiResponse;
            self.errorResult =
            [[BVSubmittedMultiProduct alloc] initWithApiResponse:apiObject];
        }
    }
    return self;
}

@end
