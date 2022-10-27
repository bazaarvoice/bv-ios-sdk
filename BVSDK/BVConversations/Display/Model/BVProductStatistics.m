//
//  ProductStatistics.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductStatistics.h"
#import "BVConversationsInclude.h"
#import "BVNullHelper.h"

@implementation BVProductStatistics

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse
                         includes:(nullable BVConversationsInclude *)includes {
  if ((self = [super init])) {
    NSDictionary *productStatistics = apiResponse[@"ProductStatistics"];

    SET_IF_NOT_NULL(self.productId, productStatistics[@"ProductId"])
    self.reviewStatistics = [[BVReviewStatistic alloc]
        initWithApiResponse:productStatistics[@"ReviewStatistics"]];
    self.nativeReviewStatistics = [[BVReviewStatistic alloc]
        initWithApiResponse:productStatistics[@"NativeReviewStatistics"]];
    self.qaStatisctics = [[BVQAStatistics alloc]
        initWithApiResponse:productStatistics[@"QAStatistics"]];
  }
  return self;
}

@end
