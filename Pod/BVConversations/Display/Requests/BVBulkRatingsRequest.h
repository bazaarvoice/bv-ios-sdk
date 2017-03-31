//
//  BVBulkRatingsRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVBulkRatingsResponse.h"
#import "BVConversationsRequest.h"
#import "BVBulkRatingsFilterType.h"
#import "PDPInclude.h"
#import "BVFilterOperator.h"

typedef NS_ENUM(NSInteger, BulkRatingsStatsType) {
    BulkRatingsStatsTypeReviews,
    BulkRatingsStatsTypeNativeReviews,
    BulkRatingsStatsTypeAll
};

typedef void (^BulkRatingsSuccessHandler)(BVBulkRatingsResponse* _Nonnull response);

/*
 You can request many products ratings (average rating, number of reviews) with this request.
 You can request up to 50 product ratings with a single request.
 */
@interface BVBulkRatingsRequest : BVConversationsRequest

- (nonnull instancetype)initWithProductIds:(NSArray<NSString *> * _Nonnull)productIds statistics:(enum BulkRatingsStatsType)statistics;
- (nonnull instancetype) __unavailable init;

- (NSString * _Nonnull)endpoint;
- (void)load:(void (^ _Nonnull)(BVBulkRatingsResponse * _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure;
- (nonnull instancetype)addFilter:(BVBulkRatingsFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString *> * _Nonnull)values;
- (NSMutableArray * _Nonnull)createParams;

@end
