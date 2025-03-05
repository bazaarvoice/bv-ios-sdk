//
//  BVQuotes.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVQuotes.h"
#import "BVQuote.h"
#import "BVNullHelper.h"

@implementation BVQuotes

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {
    if (!apiResponse) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.status, apiObject[@"status"])
    SET_IF_NOT_NULL(self.title, apiObject[@"title"])
    SET_IF_NOT_NULL(self.detail, apiObject[@"detail"])
    SET_IF_NOT_NULL(self.detail, apiObject[@"detail"])
    SET_IF_NOT_NULL(self.instance, apiObject[@"instance"])
    self.quotes = [BVQuotes parseQuotes:apiResponse[@"quotes"]];

  }
  return self;
}

+ (nonnull NSArray<BVQuote *> *)parseQuotes:(nullable id)apiResponse {
    NSMutableArray<BVQuote *> *tempValues = [NSMutableArray array];
    NSArray *apiObject = apiResponse;
    for (NSDictionary *object in apiObject) {
        [tempValues addObject:[[BVQuote alloc] initWithApiResponse:object]];
    }
    return tempValues;
}

@end
