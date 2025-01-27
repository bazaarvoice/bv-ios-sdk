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

//- (nonnull instancetype)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
//    if ((self = [super init])) {
//      NSDictionary *results = apiResponse;
//      if (results.count) {
//        _result = [self createResult:results];
//      }
//    }
//    return self;
//  }

@end
