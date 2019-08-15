//
//  BVInitiateSubmitResponse.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVInitiateSubmitResponse.h"

@implementation BVInitiateSubmitResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
    if ((self = [super initWithApiResponse:apiResponse])) {
        self.result =
        [[BVInitiateSubmitResponseData alloc] initWithApiResponse:apiResponse[@"response"]];
    }
    return self;
}

@end
