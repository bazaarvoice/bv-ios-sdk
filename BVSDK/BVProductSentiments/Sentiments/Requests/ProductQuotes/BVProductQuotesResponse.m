//
//  BVProductQuotesResponse.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVProductSentimentsResult.h"
#import "BVProductSentimentsResponse.h"
#import "BVProductQuotesResponse.h"
#import "BVProductFeatures.h"

@class BVProductSentimentsResult;

@implementation BVProductQuotesResponse
- (id)createResult:(NSDictionary *)apiResponse {
    return [[BVQuotes alloc] initWithApiResponse:apiResponse];
}

@end
