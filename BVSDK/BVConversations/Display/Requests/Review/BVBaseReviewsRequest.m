
//
//  BVBaseReviewsRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBaseReviewsRequest+Private.h"
#import "BVBrand.h"
#import "BVCommaUtil.h"
#import "BVCommon.h"
#import "BVConversationsRequest+Private.h"
#import "BVFilter.h"
#import "BVMonotonicSortOrder.h"
#import "BVProduct.h"
#import "BVRelationalFilterOperator.h"
#import "BVReview.h"
#import "BVReviewFilterType.h"
#import "BVReviewIncludeType.h"
#import "BVReviewsSortOption.h"
#import "BVSort.h"
#import "BVStringKeyValuePair.h"

@interface BVBaseReviewsRequest ()
@end

@interface BVBaseReviewsRequest ()
@end

@implementation BVBaseReviewsRequest

- (nonnull instancetype)initWithID:(nonnull NSString *)ID
                             limit:(NSUInteger)limit
                            offset:(NSUInteger)offset
                        primaryFilter:(BVReviewFilterValue)primaryFilter {
  if ((self = [super init])) {
    [self initDefaultProps:ID primaryFilter:primaryFilter];
    _limit = limit;
    _offset = offset;
  }
  return self;
}

- (void)initDefaultProps:(NSString *)ID
              primaryFilter:(BVReviewFilterValue)primaryFilter {
  _ID = [BVCommaUtil escape:ID];

  _filters = [NSMutableArray array];
  _sorts = [NSMutableArray array];
  _includes = [NSMutableArray array];
  _incentivizedStats = NO;

  // filter the request to the given productId
  BVFilter *filter = [[BVFilter alloc]
      initWithFilterType:[BVReviewFilterType filterTypeWithRawValue:
                                                 primaryFilter]
          filterOperator:[BVRelationalFilterOperator
                             filterOperatorWithRawValue:
                                 BVRelationalFilterOperatorValueEqualTo]
                  values:@[ _ID ]];
  [self.filters addObject:filter];
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];

  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"Search" value:self.search]];
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

  for (BVFilter *filter in self.filters) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Filter"
                                value:[filter toParameterString]]];
  }
  
  if (0 < self.includes.count) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Include"
                                value:[self includesToParams:self.includes]]];
  }

  if ([self.sorts count] > 0) {
    NSMutableArray<NSString *> *sortsAsStrings = [NSMutableArray array];
    for (BVSort *sort in self.sorts) {
      [sortsAsStrings addObject:[sort toParameterString]];
    }
    NSString *allTogetherNow = [sortsAsStrings componentsJoinedByString:@","];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Sort"
                                                  value:allTogetherNow]];
  }

  if (self.incentivizedStats == YES) {
    [params addObject:[BVStringKeyValuePair pairWithKey:@"incentivizedstats" value:@"true"]];
  }
  
  return params;
}

- (nonnull NSString *)includesToParams:
    (nonnull NSArray<BVIncludeType *> *)includes {

  NSMutableArray<NSString *> *includesStringArray =
      [NSMutableArray arrayWithCapacity:includes.count];

  for (BVIncludeType *include in includes) {
    [includesStringArray addObject:[include toIncludeTypeParameterString]];
  }

  NSArray<NSString *> *sortedArray = [includesStringArray
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

  return [sortedArray componentsJoinedByString:@","];
}

- (nonnull NSString *)endpoint {
  return @"reviews.json";
}

- (nonnull instancetype)search:(nonnull NSString *)search {
  // this invalidates sort options
  _search = search;
  return self;
}

- (nonnull instancetype)includeReviewIncludeTypeValue:
    (BVReviewIncludeTypeValue)reviewIncludeTypeValue {

  [self.includes addObject:[BVReviewIncludeType
                               includeTypeWithRawValue:reviewIncludeTypeValue]];

  if (reviewIncludeTypeValue == BVReviewIncludeTypeValueReviewProducts) {
    [self addCustomDisplayParameter:@"Stats"
                          withValue:@"Reviews"]; // Always include stats
                                                 // when requesting products
                                                 // with reviews
  }

  return self;
}

- (nonnull instancetype)
sortByReviewsSortOptionValue:(BVReviewsSortOptionValue)reviewsSortOptionValue
     monotonicSortOrderValue:
         (BVMonotonicSortOrderValue)monotonicSortOrderValue {
  BVSort *sort = [[BVSort alloc]
      initWithSortOption:[BVReviewsSortOption
                             sortOptionWithRawValue:reviewsSortOptionValue]
               sortOrder:[BVMonotonicSortOrder
                             sortOrderWithRawValue:monotonicSortOrderValue]];
  [self.sorts addObject:sort];
  return self;
}

- (nonnull instancetype)
    filterOnReviewFilterValue:(BVReviewFilterValue)reviewFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value {
  [self filterOnReviewFilterValue:reviewFilterValue
      relationalFilterOperatorValue:relationalFilterOperatorValue
                             values:@[ value ]];
  return self;
}

- (nonnull instancetype)
    filterOnReviewFilterValue:(BVReviewFilterValue)reviewFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                       values:(nonnull NSArray<NSString *> *)values {
  BVFilter *filter = [[BVFilter alloc]
      initWithFilterType:[BVReviewFilterType
                             filterTypeWithRawValue:reviewFilterValue]
          filterOperator:
              [BVRelationalFilterOperator
                  filterOperatorWithRawValue:relationalFilterOperatorValue]
                  values:values];
  [self.filters addObject:filter];
  return self;
}

- (void)load:(nonnull void (^)(
                 BVDisplayResponse<BVReview *> *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure {
  if (1 > self.limit || 100 < self.limit) {
    // invalid request
    [self sendError:[super limitError:self.limit] failureCallback:failure];
  } else {
    [self loadReviews:self completion:success failure:failure];
  }
}

- (void)loadReviews:(BVConversationsRequest *)request
         completion:(void (^)(BVDisplayResponse *nonnull))completion
            failure:(void (^)(NSArray<NSError *> *nonnull))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
           id reviewResponse = [self createResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(reviewResponse);
           });
           [self sendReviewsAnalytics:reviewResponse];
         }
            failure:failure];
}

- (BVDisplayResponse *)createResponse:(NSDictionary *)raw {
  NSAssert(YES, @"Should be implemented in subclasses");
  return nil;
}

- (void)sendReviewsAnalytics:(BVReviewsResponse *)reviewsResponse {
  [self sendReviewResultsAnalytics:reviewsResponse.results];
}

- (void)sendReviewResultsAnalytics:(NSArray<BVReview *> *)reviews {
  for (BVReview *review in reviews) {
    // Record Review Impression
    NSString *brandName =
        review.product.brand ? review.product.brand.name : nil;
    BVImpressionEvent *reviewImpression = [[BVImpressionEvent alloc]
           initWithProductId:review.productId
               withContentId:review.identifier
              withCategoryId:review.product.categoryId
             withProductType:BVPixelProductTypeConversationsReviews
             withContentType:BVPixelImpressionContentTypeReview
                   withBrand:brandName
        withAdditionalParams:nil];

    [BVPixel trackEvent:reviewImpression];
  }
  // send pageview for product
  BVReview *review = reviews.firstObject;
  if (review) {
    NSNumber *count = @([reviews count]);

    NSDictionary *addParams = @{@"numReviews" : count};
    NSString *brandName =
        review.product.brand ? review.product.brand.name : nil;
    BVPageViewEvent *pageView = [[BVPageViewEvent alloc]
             initWithProductId:review.productId
        withBVPixelProductType:BVPixelProductTypeConversationsReviews
                     withBrand:brandName
                withCategoryId:review.product.categoryId
            withRootCategoryId:nil
          withAdditionalParams:addParams];

    [BVPixel trackEvent:pageView];
  }
}
@end
