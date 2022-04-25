//
//  ReviewsRequest.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBaseReviewsRequest.h"
#import "BVReviewsResponse.h"
#import <Foundation/Foundation.h>

typedef void (^ReviewRequestCompletionHandler)(
    BVReviewsResponse *__nonnull response);

/*
 You can get multiple reviews and with this request object.
 Reviews can be queried using the following BVReviewFilterValues
 - BVReviewFilterValueProductId
 - BVReviewFilterValueAuthorId
 - BVReviewFilterValueSubmissionId
 - BVReviewFilterValueCategoryAncestorId
 
 Optionally, you can filter, sort, or search reviews using the `addSort*` and
 `addFilter*` and `search` methods.
 */
@interface BVReviewsRequest : BVBaseReviewsRequest <BVReviewsResponse *>

@property(nonnull, readonly) NSString *productId;
@property BOOL incentivizedStats;

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                                    limit:(NSUInteger)limit
                                   offset:(NSUInteger)offset;

- (nonnull instancetype)initWithId:(nonnull NSString *)Id
                     andFilter:(BVReviewFilterValue)filter
                             limit:(NSUInteger)limit
                            offset:(NSUInteger)offset;
- (nonnull instancetype)__unavailable init;

- (nonnull instancetype)feature:(nullable NSString *)feature;

- (nonnull instancetype)tagStats:(BOOL)tagStats;

- (nonnull instancetype)secondaryRatingStats:(BOOL)secondaryRatingStats;

@end
