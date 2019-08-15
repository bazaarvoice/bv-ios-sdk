//
//  BVProgressiveSubmitResponse.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVProgressiveSubmitResponse.h"

@implementation BVProgressiveSubmitResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
    if ((self = [super initWithApiResponse:apiResponse])) {
        self.result =
        [[BVProgressiveSubmitResponseData alloc] initWithApiResponse:apiResponse[@"response"]];
    }
    return self;
}

@end
