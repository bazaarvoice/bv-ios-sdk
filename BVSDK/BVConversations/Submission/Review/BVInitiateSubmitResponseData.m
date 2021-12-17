//
//  BVInitiateSubmitResponseData.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVInitiateSubmitResponseData.h"
#import "BVNullHelper.h"
#import "BVGenericConversationsResult+Private.h"

@implementation BVInitiateSubmitResponseData

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
    if ((self = [super init])) {
        
        if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
            return nil;
        }
        
        NSMutableDictionary *tempValues = [NSMutableDictionary dictionary];
        NSDictionary *productFormData = [apiResponse objectForKey:@"productFormData"];
        
        for (NSDictionary *value in [productFormData allValues]) {
            BVInitiateSubmitFormData *product =
            [[BVInitiateSubmitFormData alloc] initWithApiResponse:value];
            [tempValues setObject:product forKey:product.progressiveSubmissionReview.productId];
        }
        self.products = tempValues;
        self.userid = [apiResponse objectForKey:@"userId"];
        
    }
    return self;
}

@end
