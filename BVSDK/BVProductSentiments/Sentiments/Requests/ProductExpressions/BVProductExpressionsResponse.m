//
//  BVProductExpressionsResponse.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVProductSentimentsResult.h"
#import "BVProductSentimentsResponse.h"
#import "BVProductExpressionsResponse.h"
#import "BVProductFeatures.h"

@class BVProductSentimentsResult;

@implementation BVProductExpressionsResponse
- (id)createResult:(NSDictionary *)apiResponse {
    return [[BVExpressions alloc] initWithApiResponse:apiResponse];
}

@end
