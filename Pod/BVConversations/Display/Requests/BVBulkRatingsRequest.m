//
//  BVBulkRatingsRequest.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBulkRatingsRequest.h"
#import "BVCommaUtil.h"
#import "BVFilter.h"
#import "BVLogger.h"

@interface BVBulkRatingsRequest ()

@property(nonnull) NSArray<NSString *> *productIds;
@property BulkRatingsStatsType statistics;
@property(nonnull) NSMutableArray<BVFilter *> *filters;

@end

@implementation BVBulkRatingsRequest

- (nonnull NSString *)endpoint {
  return @"statistics.json";
}

- (nonnull instancetype)
initWithProductIds:(nonnull NSArray<NSString *> *)productIds
        statistics:(enum BulkRatingsStatsType)statistics {
  self = [super init];
  if (self) {
    self.productIds = [BVCommaUtil escapeMultiple:productIds];
    self.statistics = statistics;

    self.filters = [NSMutableArray array];
    BVFilter *filter = [[BVFilter alloc] initWithString:@"ProductId"
                                         filterOperator:BVFilterOperatorEqualTo
                                                 values:productIds];
    [self.filters addObject:filter];
  }
  return self;
}

- (void)load:
            (nonnull void (^)(BVBulkRatingsResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure {
  if ([self.productIds count] > 100) {
    // invalid request
    [self sendError:[self tooManyProductsError:self.productIds]
        failureCallback:failure];
  } else {
    [self loadBulkRatings:self completion:success failure:failure];
  }
}

- (void)
loadBulkRatings:(nonnull BVConversationsRequest *)request
     completion:
         (nonnull void (^)(BVBulkRatingsResponse *__nonnull response))completion
        failure:
            (nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {

           BVBulkRatingsResponse *bulkRatingsResponse =
               [[BVBulkRatingsResponse alloc] initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(bulkRatingsResponse);
           });

         }
            failure:failure];
}

- (nonnull instancetype)addFilter:(BVBulkRatingsFilterType)type
                   filterOperator:(BVFilterOperator)filterOperator
                           values:(nonnull NSArray<NSString *> *)values {
  BVFilter *filter = [[BVFilter alloc]
      initWithString:[BVBulkRatingsFilterTypeUtil toString:type]
      filterOperator:filterOperator
              values:values];
  [self.filters addObject:filter];
  return self;
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];

  [params addObject:[BVStringKeyValuePair
                        pairWithKey:@"Stats"
                              value:[self statsToString:self.statistics]]];

  for (BVFilter *filter in self.filters) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Filter"
                                value:[filter toParameterString]]];
  }

  return params;
}

- (nonnull NSString *)statsToString:(BulkRatingsStatsType)stats {
  switch (stats) {
  case BulkRatingsStatsTypeReviews:
    return @"Reviews";
  case BulkRatingsStatsTypeNativeReviews:
    return @"NativeReviews";
  case BulkRatingsStatsTypeAll:
    return @"Reviews,NativeReviews";
  }
}

@end
