//
//  BVProgressiveSubmitErrorResponse.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVProgressiveSubmitErrorResponse.h"
#import "BVNullHelper.h"
#import "BVFieldError.h"
#import "BVSubmissionErrorResponse+Private.h"

@implementation BVProgressiveSubmitErrorResponse

- (instancetype)initWithApiResponse:(nullable id)apiResponse {
    if ((self = [super initWithApiResponse:apiResponse])) {
        if (__IS_KIND_OF(apiResponse, NSDictionary)) {
            NSDictionary *apiObject = (NSDictionary *)apiResponse;
            NSDictionary *responseObject = apiObject[@"response"];
            
            NSMutableArray *tempValues = [NSMutableArray array];
            for (NSDictionary *fieledError in responseObject[@"formValidationErrors"]) {
                BVFieldError *error = [[BVFieldError alloc] initWithApiResponse:fieledError];
                [tempValues addObject:error];
            }
            self.fieldErrors = tempValues;
            self.errorResult =
            [[BVProgressiveSubmitResponseData alloc] initWithApiResponse:apiObject];
        }
    }
    return self;
}

@end
