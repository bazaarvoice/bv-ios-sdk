//
//  ReviewsRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVReviewFilterType.h"
#import "BVFilterOperator.h"
#import "BVSortOptionReviews.h"
#import "BVSort.h"
#import "BVReviewsResponse.h"
#import "BVBaseReviewsRequest.h"

typedef void (^ReviewRequestCompletionHandler)(BVReviewsResponse* _Nonnull response);

/*
 You can get multiple reviews and with this request object.
 Optionally, you can filter, sort, or search reviews using the `addSort*` and `addFilter*` and `search` methods.
 */
@interface BVReviewsRequest : BVBaseReviewsRequest<BVReviewsResponse *>

@property (readonly) NSString* _Nonnull productId;

- (nonnull instancetype)initWithProductId:(NSString * _Nonnull)productId limit:(int)limit offset:(int)offset;
- (nonnull instancetype) __unavailable init;

@end
