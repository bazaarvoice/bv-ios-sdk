//
//  BVStoreItemsRequest.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import "BVBulkStoreItemsRequest.h"
#import "BVPDPIncludeType.h"
#import "BVProductFilterType.h"
#import "BVRelationalFilterOperator.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager.h"
#import "BVStoreIncludeType.h"

@interface BVBulkStoreItemsRequest ()

@property NSUInteger limit;
@property NSUInteger offset;
@property(nonnull) NSMutableArray<BVStoreIncludeType *> *storeIncludeTypes;
@property(nonnull) NSArray<NSString *> *filterStoreIds;

@end

@implementation BVBulkStoreItemsRequest

- (nonnull instancetype)init:(NSUInteger)limit offset:(NSUInteger)offset {
  self = [super init];
  if (self) {
    self.limit = limit;
    self.offset = offset;
    [self initDefaultProps];
  }
  return self;
}

- (nonnull instancetype)initWithStoreIds:(nonnull NSArray *)storeIds {
  self = [super init];
  if (self) {
    self.limit = [storeIds count];
    self.offset = 0;
    [self initDefaultProps];
    _filterStoreIds = storeIds;
  }
  return self;
}

- (void)initDefaultProps {
  _filterStoreIds = [NSArray array];
  _storeIncludeTypes = [NSMutableArray array];
}

- (void)load:(nonnull void (^)(BVBulkStoresResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure {
  [self loadStores:self completion:success failure:failure];
}

- (void)loadStores:(nonnull BVConversationsRequest *)request
        completion:(nonnull void (^)(BVBulkStoresResponse *__nonnull response))
                       completion
           failure:
               (nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
           BVBulkStoresResponse *storesResponse =
               [[BVBulkStoresResponse alloc] initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(storesResponse);
           });

           if ([storesResponse.results count] == 1) {
             [self sendStoreAnalytics:storesResponse.results[0]];
           }

         }
            failure:failure];
}

- (void)sendStoreAnalytics:(BVStore *)store {
  if (store) {
    // send pageview for product

    BVPageViewEvent *pageView = [[BVPageViewEvent alloc]
             initWithProductId:store.identifier
        withBVPixelProductType:BVPixelProductTypeConversationsReviews
                     withBrand:nil
                withCategoryId:store.categoryId
            withRootCategoryId:nil
          withAdditionalParams:nil];

    [BVPixel trackEvent:pageView];
  }
}

- (nonnull NSString *)endpoint {
  return @"products.json";
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];

  [params
      addObject:[BVStringKeyValuePair
                    pairWithKey:@"Limit"
                          value:[NSString
                                    stringWithFormat:@"%i", (int)self.limit]]];
  [params
      addObject:[BVStringKeyValuePair
                    pairWithKey:@"Offset"
                          value:[NSString
                                    stringWithFormat:@"%i", (int)self.offset]]];

  if (self.storeIncludeTypes.count) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Stats"
                                value:[self statisticsToParams:
                                                self.storeIncludeTypes]]];
  }

  if ([self.filterStoreIds count] > 0) {
    BVFilter *filter = [[BVFilter alloc]
        initWithFilterType:
            [BVProductFilterType
                filterTypeWithRawValue:BVProductFilterValueProductId]
            filterOperator:[BVRelationalFilterOperator
                               filterOperatorWithRawValue:
                                   BVRelationalFilterOperatorValueEqualTo]
                    values:self.filterStoreIds];
    NSString *filterValue = [filter toParameterString];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter"
                                                  value:filterValue]];
  }

  return params;
}

- (nonnull instancetype)includeStatistics:
    (BVStoreIncludeTypeValue)storeIncludeTypeValue {
  [self.storeIncludeTypes
      addObject:[BVStoreIncludeType
                    includeTypeWithRawValue:storeIncludeTypeValue]];
  return self;
}

- (nonnull NSString *)statisticsToParams:
    (nonnull NSArray<BVStoreIncludeType *> *)statistics {
  NSMutableArray<NSString *> *strings = [NSMutableArray array];

  for (BVStoreIncludeType *stat in statistics) {
    [strings addObject:[stat toIncludeTypeParameterString]];
  }

  NSArray<NSString *> *sortedArray = [strings
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

  return [sortedArray componentsJoinedByString:@","];
}

- (NSString *)getPassKey {
  return [BVSDKManager sharedManager].configuration.apiKeyConversationsStores;
}
@end
