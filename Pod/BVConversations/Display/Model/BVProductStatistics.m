//
//  ProductStatistics.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductStatistics.h"
#import "BVNullHelper.h"

@implementation BVProductStatistics

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {

  self = [super init];
  if (self) {
    NSDictionary *productStatistics = apiResponse[@"ProductStatistics"];

    SET_IF_NOT_NULL(self.productId, productStatistics[@"ProductId"])
    self.reviewStatistics = [[BVReviewStatistic alloc]
        initWithApiResponse:productStatistics[@"ReviewStatistics"]];
    self.nativeReviewStatistics = [[BVReviewStatistic alloc]
        initWithApiResponse:productStatistics[@"NativeReviewStatistics"]];
  }
  return self;
}

@end
