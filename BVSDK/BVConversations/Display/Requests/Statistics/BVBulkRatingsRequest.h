//
//  BVBulkRatingsRequest.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBulkRatingsResponse.h"
#import "BVConversationDisplay.h"
#import "BVConversationsRequest.h"
#import <Foundation/Foundation.h>

typedef void (^BulkRatingsSuccessHandler)(
    BVBulkRatingsResponse *__nonnull response);

/*
 You can request many products ratings (average rating, number of reviews) with
 this request.
 You can request up to 50 product ratings with a single request.
 */
@interface BVBulkRatingsRequest : BVConversationsRequest

@property BOOL incentivizedStats;

- (nonnull instancetype)
initWithProductIds:(nonnull NSArray<NSString *> *)productIds
        statistics:(BVBulkRatingIncludeTypeValue)bulkRatingIncludeTypeValue;
- (nonnull instancetype)__unavailable init;

- (nonnull NSString *)endpoint;
- (void)load:
            (nonnull void (^)(BVBulkRatingsResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;
- (nonnull instancetype)
filterOnBulkRatingFilterValue:(BVBulkRatingFilterValue)bulkRatingFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value;
- (nonnull instancetype)
filterOnBulkRatingFilterValue:(BVBulkRatingFilterValue)bulkRatingFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                       values:(nonnull NSArray<NSString *> *)values;
- (nonnull NSMutableArray *)createParams;

@end
