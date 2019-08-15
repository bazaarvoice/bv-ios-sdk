//
//  BVMultiProductInfo.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVMultiProductInfo.h"
#import "BVNullHelper.h"

@implementation BVMultiProductInfo
- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
    if ((self = [super init])) {
        
        if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
            return nil;
        }
        SET_IF_NOT_NULL(self.identifier, apiResponse[@"id"])
        SET_IF_NOT_NULL(self.name, apiResponse[@"name"])
        SET_IF_NOT_NULL(self.imageUrl, apiResponse[@"imageUrl"])
        SET_IF_NOT_NULL(self.productDescription, apiResponse[@"description"])
        SET_IF_NOT_NULL(self.productPageUrl, apiResponse[@"pageUrl"])
        SET_IF_NOT_NULL(self.totalReviewCount, apiResponse[@"totalReviewCount"])
        SET_IF_NOT_NULL(self.averageOverallRating, apiResponse[@"averageRating"])
        SET_IF_NOT_NULL(self.rating, apiResponse[@"rating"])
        SET_IF_NOT_NULL(self.reviewTitle, apiResponse[@"reviewTitle"])
        SET_IF_NOT_NULL(self.reviewText, apiResponse[@"reviewText"])
        SET_IF_NOT_NULL(self.isMissing, apiResponse[@"isMissing"])
    }
    return self;
}
@end
