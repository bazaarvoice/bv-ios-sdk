//
//  BVSubmittedIncrementalReview.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVSubmittedIncrementalReview.h"
#import "BVNullHelper.h"
#import "BVGenericConversationsResult+Private.h"

@implementation BVSubmittedIncrementalReview
- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
    if ((self = [super init])) {
        
        if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
            return nil;
        }
        NSDictionary *apiObject = (NSDictionary *)apiResponse;
        SET_IF_NOT_NULL(self.mprToken, apiObject[@"mprToken"])
        SET_IF_NOT_NULL(self.submissionId, apiObject[@"submissionId"])
        self.review = [[BVSubmittedReview alloc] initWithApiResponse:apiObject[@"review"]];
    }
    return self;
}

@end
