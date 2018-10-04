

//
//  BVCommentsRequest.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentFilterType.h"
#import "BVCommentIncludeType.h"
#import "BVCommentsRequest+Private.h"
#import "BVCommentsSortOption.h"
#import "BVConversationsRequest+Private.h"
#import "BVImpressionEvent.h"
#import "BVMonotonicSortOrder.h"
#import "BVPixel.h"
#import "BVRelationalFilterOperator.h"

@interface BVCommentsRequest ()
@end

@implementation BVCommentsRequest

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                              andReviewId:(nonnull NSString *)reviewId
                                    limit:(UInt16)limit
                                   offset:(UInt16)offset {
  if ((self = [super init])) {
    _productId = productId;
    _reviewId = reviewId;
    _limit = limit;
    _offset = offset;
    _filters = [NSMutableArray array];
    _sorts = [NSMutableArray array];
    _includes = [NSMutableArray array];
  }
  return self;
}

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                             andCommentId:(nonnull NSString *)commentId {
  if ((self = [super init])) {
    _productId = productId;
    _commentId = commentId;
    _filters = [NSMutableArray array];
    _sorts = [NSMutableArray array];
    _includes = [NSMutableArray array];
  }
  return self;
}

- (void)load:(nonnull void (^)(BVCommentsResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure {
  if (self.reviewId && (1 > self.limit || 100 < self.limit)) {
    // invalid request
    [self sendError:[super limitError:self.limit] failureCallback:failure];
  } else {
    [self loadComments:self completion:success failure:failure];
  }
}

- (void)
loadComments:(nonnull BVConversationsRequest *)request
  completion:
      (nonnull void (^)(BVCommentsResponse *__nonnull response))completion
     failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {

           BVCommentsResponse *commentsResponse =
               [[BVCommentsResponse alloc] initWithApiResponse:response];

           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(commentsResponse);
           });

           if (commentsResponse && commentsResponse.results) {
             [self sendCommentImpressionAnalytics:commentsResponse.results];
           }

         }
            failure:failure];
}

- (nonnull NSString *)endpoint {
  return @"reviewcomments.json";
}

- (void)sendCommentImpressionAnalytics:(NSArray<BVComment *> *)comments {
  for (BVComment *comment in comments) {
    // Record Review Impression
    BVImpressionEvent *commentImpression = [[BVImpressionEvent alloc]
           initWithProductId:comment.reviewId
               withContentId:comment.commentId
              withCategoryId:nil
             withProductType:BVPixelProductTypeConversationsReviews
             withContentType:BVPixelImpressionContentTypeComment
                   withBrand:nil
        withAdditionalParams:nil];

    [BVPixel trackEvent:commentImpression];
  }
}

- (nonnull NSMutableArray *)createParams {

  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];

  // There are two ways to make a request with a product identifier: 1) with a
  // review identifier to get a bunch of comments or 2) with a comment
  // identifier to just get single review.
  NSAssert(self.productId, @"You must supply a valid product identifier in the "
                           @"supplied initiaizers.");

  NSAssert(self.commentId || self.reviewId, @"You must also supply a valid "
                                            @"comment or review identifier in "
                                            @"the supplied initiaizers.");

  if (self.productId) {

    BVFilter *commentProductIdFilter = [[BVFilter alloc]
        initWithFilterType:
            [BVCommentFilterType
                filterTypeWithRawValue:BVCommentFilterValueCommentProductId]
            filterOperator:[BVRelationalFilterOperator
                               filterOperatorWithRawValue:
                                   BVRelationalFilterOperatorValueEqualTo]
                     value:self.productId];

    [self.filters addObject:commentProductIdFilter];
  }

  if (self.reviewId) {

    BVFilter *commentReviewIdFilter = [[BVFilter alloc]
        initWithFilterType:
            [BVCommentFilterType
                filterTypeWithRawValue:BVCommentFilterValueCommentReviewId]
            filterOperator:[BVRelationalFilterOperator
                               filterOperatorWithRawValue:
                                   BVRelationalFilterOperatorValueEqualTo]
                     value:self.reviewId];

    [self.filters addObject:commentReviewIdFilter];

    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Limit"
                                value:[NSString
                                          stringWithFormat:@"%i", self.limit]]];
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Offset"
                                value:[NSString stringWithFormat:@"%i",
                                                                 self.offset]]];
  }

  if (self.commentId) {
    BVFilter *commentIdFilter = [[BVFilter alloc]
        initWithFilterType:
            [BVCommentFilterType
                filterTypeWithRawValue:BVCommentFilterValueCommentId]
            filterOperator:[BVRelationalFilterOperator
                               filterOperatorWithRawValue:
                                   BVRelationalFilterOperatorValueEqualTo]
                     value:self.commentId];

    [self.filters addObject:commentIdFilter];
  }

  for (BVFilter *filter in self.filters) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Filter"
                                value:[filter toParameterString]]];
  }

  if (0 < self.sorts.count) {
    [params addObject:[self sortParams:self.sorts withKey:@"Sort"]];
  }

  if (0 < self.includes.count) {
    [params addObject:[BVStringKeyValuePair
                          pairWithKey:@"Include"
                                value:[self includesToParams:self.includes]]];
  }

  return params;
}

- (nonnull instancetype)
sortByCommentsSortOptionValue:(BVCommentsSortOptionValue)commentsSortOptionValue
      monotonicSortOrderValue:
          (BVMonotonicSortOrderValue)monotonicSortOrderValue {
  BVSort *sort = [[BVSort alloc]
      initWithSortOption:[BVCommentsSortOption
                             sortOptionWithRawValue:commentsSortOptionValue]
               sortOrder:[BVMonotonicSortOrder
                             sortOrderWithRawValue:monotonicSortOrderValue]];
  [self.sorts addObject:sort];
  return self;
}

- (nonnull instancetype)
   filterOnCommentFilterValue:(BVCommentFilterValue)commentFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value {
  [self filterOnCommentFilterValue:commentFilterValue
      relationalFilterOperatorValue:relationalFilterOperatorValue
                             values:@[ value ]];
  return self;
}

- (nonnull instancetype)
   filterOnCommentFilterValue:(BVCommentFilterValue)commentFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                       values:(nonnull NSArray<NSString *> *)values {
  BVCommentFilterType *commentsRequestFilterType =
      [BVCommentFilterType filterTypeWithRawValue:commentFilterValue];
  BVRelationalFilterOperator *relationalFilterOperatorType =
      [BVRelationalFilterOperator
          filterOperatorWithRawValue:relationalFilterOperatorValue];
  [self addCommentsRequestFilterType:commentsRequestFilterType
            relationalFilterOperator:relationalFilterOperatorType
                              values:values];
  return self;
}

- (nonnull instancetype)
addCommentsRequestFilterType:
    (nonnull BVCommentFilterType *)commentsRequestFilterType
    relationalFilterOperator:
        (nonnull BVRelationalFilterOperator *)filterOperator
                      values:(nonnull NSArray<NSString *> *)values {
  BVFilter *filter =
      [[BVFilter alloc] initWithFilterType:commentsRequestFilterType
                            filterOperator:filterOperator
                                    values:values];
  [self.filters addObject:filter];
  return self;
}

- (nonnull instancetype)includeCommentIncludeTypeValue:
    (BVCommentIncludeTypeValue)commentIncludeTypeValue {

  BVCommentIncludeType *commentIncludeType =
      [BVCommentIncludeType includeTypeWithRawValue:commentIncludeTypeValue];

  [self.includes addObject:commentIncludeType];
  return self;
}

- (nonnull BVStringKeyValuePair *)sortParams:(nonnull NSArray<BVSort *> *)sorts
                                     withKey:(NSString *)paramKey {
  NSMutableArray *strings = [NSMutableArray array];

  for (BVSort *sort in sorts) {
    [strings addObject:[sort toParameterString]];
  }

  NSString *combined = [strings componentsJoinedByString:@","];

  return [BVStringKeyValuePair pairWithKey:paramKey value:combined];
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

@end
