//
//  ReviewsRequest.h
//  Conversations
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
 Optionally, you can filter, sort, or search reviews using the `addSort*` and
 `addFilter*` and `search` methods.
 */
@interface BVReviewsRequest : BVBaseReviewsRequest <BVReviewsResponse *>

@property(nonnull, readonly) NSString *productId;

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                                    limit:(NSUInteger)limit
                                   offset:(NSUInteger)offset;
- (nonnull instancetype)__unavailable init;

@end
