//
//  BVInitiateSubmitErrorResponse.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVInitiateSubmitErrorResponse.h"
#import "BVNullHelper.h"

@implementation BVInitiateSubmitErrorResponse

- (instancetype)initWithApiResponse:(nullable id)apiResponse {
    if ((self = [super initWithApiResponse:apiResponse])) {
        if (__IS_KIND_OF(apiResponse, NSDictionary)) {
            NSDictionary *apiObject = (NSDictionary *)apiResponse;
            self.errorResult =
            [[BVInitiateSubmitResponseData alloc] initWithApiResponse:apiObject];
        }
    }
    return self;
}

@end
