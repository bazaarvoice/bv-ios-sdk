//
//  BVSummarisedFeaturesQuotesResponse.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>

#import "BVProductSentimentsResult.h"
#import "BVProductSentimentsResponse.h"
#import "BVSummarisedFeaturesQuotesResponse.h"
#import "BVQuotes.h"

@class BVProductSentimentsResult;

@implementation BVSummarisedFeaturesQuotesResponse
- (id)createResult:(NSDictionary *)apiResponse {
    return [[BVQuotes alloc] initWithApiResponse:apiResponse];
}

@end
