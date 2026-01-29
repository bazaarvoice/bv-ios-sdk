//
//  BVMatchedTokensSubmissionResponse.m
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

#import "BVMatchedTokensSubmissionResponse.h"
#import "BVMatchedTokens.h"

@implementation BVMatchedTokensSubmissionResponse

- (nonnull instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
    if ((self = [super initWithApiResponse:apiResponse])) {
        self.result = [[BVMatchedTokens alloc]
                       initWithApiResponse:apiResponse] ;
    }
    return self;
}

@end
