//
//  BVMultiProductSubmissionResponse.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVMultiProductSubmissionResponse.h"

@implementation BVMultiProductSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
    if ((self = [super initWithApiResponse:apiResponse])) {
        self.result =
        [[BVSubmittedMultiProduct alloc] initWithApiResponse:apiResponse[@"response"]];
    }
    return self;
}

@end
