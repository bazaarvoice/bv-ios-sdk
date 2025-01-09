//
//  BVProductFeaturesResponse.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVProductSentimentsResult.h"
#import "BVProductSentimentsResponse.h"
#import "BVProductFeaturesResponse.h"
#import "BVProductFeatures.h"

@class BVProductSentimentsResult;

@implementation BVProductFeaturesResponse
- (id)createResult:(NSDictionary *)apiResponse {
    return [[BVProductFeatures alloc] initWithApiResponse:apiResponse];
}

@end
