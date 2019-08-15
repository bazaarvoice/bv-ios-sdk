//
//  BVSubmittedMultiProduct.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVSubmittedMultiProduct.h"
#import "BVNullHelper.h"
#import "BVGenericConversationsResult+Private.h"

@implementation BVSubmittedMultiProduct

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
    if ((self = [super init])) {
        
        if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
            return nil;
        }
        
        NSDictionary *apiObject = (NSDictionary *)apiResponse;
        NSMutableArray *tempValues = [NSMutableArray array];
        for (NSDictionary *value in apiObject[@"products"]) {
            BVMultiProductInfo *product =
            [[BVMultiProductInfo alloc] initWithApiResponse:value];
            [tempValues addObject:product];
        }
        self.products = tempValues;
        SET_IF_NOT_NULL(self.interactionId, apiObject[@"uniqueInteractionId"])
        SET_IF_NOT_NULL(self.userNickname, apiObject[@"userNickname"])
    }
    return self;
}

@end
