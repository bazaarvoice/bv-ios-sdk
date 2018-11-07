//
//  BVBulkRatingsRequest.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBulkRatingsRequest.h"
#import "BVBulkRatingFilterType.h"
#import "BVBulkRatingIncludeType.h"
#import "BVCommaUtil.h"
#import "BVConversationsRequest+Private.h"
#import "BVLogger+Private.h"
#import "BVRelationalFilterOperator.h"
#import "BVStringKeyValuePair.h"

@interface BVBulkRatingsRequest ()

@property(nonnull) NSArray<NSString *> *productIds;
@property(nonnull) NSMutableArray<BVBulkRatingIncludeType *> *statistics;
@property(nonnull) NSMutableArray<BVFilter *> *filters;

@end

@implementation BVBulkRatingsRequest

- (nonnull NSString *)endpoint {
  return @"statistics.json";
}

- (nonnull instancetype)
initWithProductIds:(nonnull NSArray<NSString *> *)productIds
        statistics:(BVBulkRatingIncludeTypeValue)bulkRatingIncludeTypeValue {
  if ((self = [super init])) {
    self.productIds = [BVCommaUtil escapeMultiple:productIds];

    /// This is a single element array for now...
    self.statistics = [NSMutableArray arrayWithArray:@[
      [BVBulkRatingIncludeType
          includeTypeWithRawValue:bulkRatingIncludeTypeValue]
    ]];

    self.filters = [NSMutableArray array];
    BVFilter *filter = [[BVFilter alloc]
        initWithFilterType:[BVBulkRatingFilterType
                               filterTypeWithRawValue:
                                   BVBulkRatingFilterValueBulkRatingProductId]
            filterOperator:[BVRelationalFilterOperator
                               filterOperatorWithRawValue:
                                   BVRelationalFilterOperatorValueEqualTo]
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

- (nonnull instancetype)
addBulkRatingsFilterType:(nonnull BVBulkRatingFilterType *)bulkRatingsFilterType
relationalFilterOperator:
    (nonnull BVRelationalFilterOperator *)relationalFilterOperator
                  values:(nonnull NSArray<NSString *> *)values {
  BVFilter *filter =
      [[BVFilter alloc] initWithFilterType:bulkRatingsFilterType
                            filterOperator:relationalFilterOperator
                                    values:values];
  [self.filters addObject:filter];
  return self;
}

- (nonnull instancetype)
filterOnBulkRatingFilterValue:(BVBulkRatingFilterValue)bulkRatingFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value {
  [self filterOnBulkRatingFilterValue:bulkRatingFilterValue
        relationalFilterOperatorValue:relationalFilterOperatorValue
                               values:@[ value ]];
  return self;
}

- (nonnull instancetype)
filterOnBulkRatingFilterValue:(BVBulkRatingFilterValue)bulkRatingFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                       values:(nonnull NSArray<NSString *> *)values {
  BVBulkRatingFilterType *bulkRatingsFilterType =
      [BVBulkRatingFilterType filterTypeWithRawValue:bulkRatingFilterValue];
  BVRelationalFilterOperator *relationalFilterOperator =
      [BVRelationalFilterOperator
          filterOperatorWithRawValue:relationalFilterOperatorValue];
  [self addBulkRatingsFilterType:bulkRatingsFilterType
        relationalFilterOperator:relationalFilterOperator
                          values:values];
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

- (nonnull NSString *)statsToString:
    (NSMutableArray<BVBulkRatingIncludeType *> *)statistics {
  NSMutableArray<NSString *> *statisticsStringArray =
      [NSMutableArray arrayWithCapacity:statistics.count];

  for (BVBulkRatingIncludeType *stat in statistics) {
    [statisticsStringArray addObject:[stat toIncludeTypeParameterString]];
  }

  NSArray<NSString *> *sortedArray = [statisticsStringArray
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

  return [sortedArray componentsJoinedByString:@","];
}

@end
