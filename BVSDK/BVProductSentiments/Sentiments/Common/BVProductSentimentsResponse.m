//
//  BVProductSentimentsResponse.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVProductSentimentsResponse.h"
#import "BVProductSentimentsResult.h"
#import "BVSummarisedFeatures.h"

@implementation BVProductSentimentsResponse

- (id)createResult:(NSDictionary *)raw {
  NSAssert(NO, @"createResult method should be overridden");
  return nil;
}

- (id)initWithApiResponse:(NSDictionary *)apiResponse {
//  if ((self = [super initWithApiResponse:apiResponse])) {
    NSDictionary *result = apiResponse;
    if (result) {
        _result = [self createResult:result];
    }
//  }
  return self;
}

@end
