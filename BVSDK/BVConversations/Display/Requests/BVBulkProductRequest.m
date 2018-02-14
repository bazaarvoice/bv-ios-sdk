//
//  BVBulkProductRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBulkProductRequest.h"
#import "BVMonotonicSortOrder.h"
#import "BVProductFilterType.h"
#import "BVProductsSortOption.h"
#import "BVRelationalFilterOperator.h"

@interface BVBulkProductRequest ()

@property(nonnull) NSMutableArray<BVSort *> *sorts;
@property(nonnull, nonatomic, strong) NSMutableArray<BVFilter *> *filters;

@end

@implementation BVBulkProductRequest

- (instancetype)init {
  if ((self = [super init])) {
    _sorts = [NSMutableArray new];
    _filters = [NSMutableArray new];
  }

  return self;
}

- (nonnull instancetype)
sortByProductsSortOptionValue:(BVProductsSortOptionValue)productsSortOptionValue
      monotonicSortOrderValue:
          (BVMonotonicSortOrderValue)monotonicSortOrderValue {
  BVSort *sort = [[BVSort alloc]
      initWithSortOption:[BVProductsSortOption
                             sortOptionWithRawValue:monotonicSortOrderValue]
               sortOrder:[BVMonotonicSortOrder
                             sortOrderWithRawValue:monotonicSortOrderValue]];
  [self.sorts addObject:sort];
  return self;
}

- (void)load:(ProductSearchRequestCompletionHandler)success
     failure:(ConversationsFailureHandler)failure {
  [self loadContent:self
         completion:^(NSDictionary *__nonnull response) {
           BVBulkProductResponse *productsResponse =
               [[BVBulkProductResponse alloc] initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             success(productsResponse);
           });

         }
            failure:failure];
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];
  if ([self.sorts count] > 0) {
    NSMutableArray<NSString *> *sortsAsStrings = [NSMutableArray array];
    for (BVSort *sort in self.sorts) {
      [sortsAsStrings addObject:[sort toParameterString]];
    }
    NSString *allTogetherNow = [sortsAsStrings componentsJoinedByString:@","];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Sort"
                                                  value:allTogetherNow]];
  }

  for (BVFilter *filter in self.filters) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Filter"
                                value:[filter toParameterString]]];
  }

  return params;
}

- (nonnull instancetype)
   filterOnProductFilterValue:(BVProductFilterValue)productFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value {
  [self filterOnProductFilterValue:productFilterValue
      relationalFilterOperatorValue:relationalFilterOperatorValue
                             values:@[ value ]];
  return self;
}

- (nonnull instancetype)
   filterOnProductFilterValue:(BVProductFilterValue)productFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                       values:(nonnull NSArray<NSString *> *)values {
  BVProductFilterType *productFilterType =
      [BVProductFilterType filterTypeWithRawValue:productFilterValue];

  BVRelationalFilterOperator *relationalFilterOperator =
      [BVRelationalFilterOperator
          filterOperatorWithRawValue:relationalFilterOperatorValue];

  [self addProductFilterType:productFilterType
      relationalFilterOperator:relationalFilterOperator
                        values:values];
  return self;
}

- (nonnull instancetype)
    addProductFilterType:(nonnull BVProductFilterType *)productFilterType
relationalFilterOperator:(nonnull BVFilterOperator *)relationalFilterOperator
                  values:(nonnull NSArray<NSString *> *)values {
  BVFilter *filter =
      [[BVFilter alloc] initWithFilterType:productFilterType
                            filterOperator:relationalFilterOperator
                                    values:values];
  [self.filters addObject:filter];
  return self;
}

@end
