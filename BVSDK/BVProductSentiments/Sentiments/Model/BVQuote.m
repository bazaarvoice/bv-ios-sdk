//
//  BVQuote.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVQuote.h"
#import "BVNullHelper.h"

@implementation BVQuote

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {
    if (!apiResponse) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.quoteID, apiObject[@"quoteId"])
    SET_IF_NOT_NULL(self.text, apiObject[@"text"])
    SET_IF_NOT_NULL(self.emotion, apiObject[@"emotion"])
    SET_IF_NOT_NULL(self.reviewRating, apiObject[@"reviewRating"])
    SET_IF_NOT_NULL(self.reviewID, apiObject[@"reviewId"])
    SET_IF_NOT_NULL(self.reviewedAt, apiObject[@"reviewedAt"])
    SET_IF_NOT_NULL(self.translatedText, apiObject[@"translatedText"])
    SET_IF_NOT_NULL(self.nativeLanguage, apiObject[@"nativeLanguage"])
    SET_IF_NOT_NULL(self.incentivised, apiObject[@"incentivised"])
    SET_IF_NOT_NULL(self.reviewType, apiObject[@"reviewType"])
  }
  return self;
}

@end
