//
//  BVStoreItemsRequest.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import "BVBulkStoreItemsRequest.h"
#import "BVFilter.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager.h"
#import "PDPInclude.h"

@interface BVBulkStoreItemsRequest ()

@property int limit;
@property int offset;
@property(nonnull) NSMutableArray<NSNumber *> *storeContentTypeStatistics;
@property(nonnull) NSArray<NSString *> *filterStoreIds;

@end

@implementation BVBulkStoreItemsRequest

- (nonnull instancetype)init:(int)limit offset:(int)offset {
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
    self.limit = (int)[storeIds count];
    self.offset = 0;
    [self initDefaultProps];
    _filterStoreIds = storeIds;
  }
  return self;
}

- (void)initDefaultProps {
  _filterStoreIds = [NSArray array];
  self.storeContentTypeStatistics = [NSMutableArray array];
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
                          value:[NSString stringWithFormat:@"%i", self.limit]]];
  [params addObject:[BVStringKeyValuePair
                        pairWithKey:@"Offset"
                              value:[NSString
                                        stringWithFormat:@"%i", self.offset]]];

  if (_storeContentTypeStatistics.count) {
    [params
        addObject:[BVStringKeyValuePair
                      pairWithKey:@"Stats"
                            value:[self statisticsToParams:
                                            self.storeContentTypeStatistics]]];
  }

  if ([self.filterStoreIds count] > 0) {
    BVFilter *filter = [[BVFilter alloc]
        initWithString:[BVProductFilterTypeUtil toString:BVProductFilterTypeId]
        filterOperator:BVFilterOperatorEqualTo
                values:self.filterStoreIds];
    NSString *filterValue = [filter toParameterString];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter"
                                                  value:filterValue]];
  }

  return params;
}

- (nonnull instancetype)includeStatistics:
    (BVStoreIncludeContentType)contentType {
  [self.storeContentTypeStatistics addObject:@(contentType)];
  return self;
}

- (nonnull NSString *)statisticsToParams:
    (nonnull NSArray<NSNumber *> *)statistics {
  NSMutableArray *strings = [NSMutableArray array];

  for (NSNumber *stat in statistics) {
    [strings addObject:[PDPContentTypeUtil toString:[stat intValue]]];
  }

  NSArray<NSString *> *sortedArray = [strings
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

  return [sortedArray componentsJoinedByString:@","];
}

- (NSString *)getPassKey {
  return [BVSDKManager sharedManager].configuration.apiKeyConversationsStores;
}
@end
