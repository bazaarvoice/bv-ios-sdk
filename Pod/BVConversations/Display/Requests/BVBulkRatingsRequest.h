//
//  BVBulkRatingsRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBulkRatingsFilterType.h"
#import "BVBulkRatingsResponse.h"
#import "BVConversationsRequest.h"
#import "BVFilterOperator.h"
#import "PDPInclude.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BulkRatingsStatsType) {
  BulkRatingsStatsTypeReviews,
  BulkRatingsStatsTypeNativeReviews,
  BulkRatingsStatsTypeAll
};

typedef void (^BulkRatingsSuccessHandler)(
    BVBulkRatingsResponse *__nonnull response);

/*
 You can request many products ratings (average rating, number of reviews) with
 this request.
 You can request up to 50 product ratings with a single request.
 */
@interface BVBulkRatingsRequest : BVConversationsRequest

- (nonnull instancetype)
initWithProductIds:(nonnull NSArray<NSString *> *)productIds
        statistics:(enum BulkRatingsStatsType)statistics;
- (nonnull instancetype)__unavailable init;

- (nonnull NSString *)endpoint;
- (void)load:
            (nonnull void (^)(BVBulkRatingsResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;
- (nonnull instancetype)addFilter:(BVBulkRatingsFilterType)type
                   filterOperator:(BVFilterOperator)filterOperator
                           values:(nonnull NSArray<NSString *> *)values;
- (nonnull NSMutableArray *)createParams;

@end
