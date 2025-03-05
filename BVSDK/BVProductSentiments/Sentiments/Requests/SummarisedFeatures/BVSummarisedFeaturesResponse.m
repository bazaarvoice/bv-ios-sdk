//
//  BVSummarisedFeaturesResponse.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>

#import "BVProductSentimentsResult.h"
#import "BVProductSentimentsResponse.h"
#import "BVSummarisedFeaturesResponse.h"
#import "BVSummarisedFeatures.h"

@class BVProductSentimentsResult;

@implementation BVSummarisedFeaturesResponse
- (id)createResult:(NSDictionary *)apiResponse {
    return [[BVSummarisedFeatures alloc] initWithApiResponse:apiResponse];
}

@end
