//
//  BVReviewHighlightsRequest.h
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import "BVReviewHighlightsResponse.h"
#import "BVConversationsRequest.h"

/** This class allow you to build request parameters and request a Review Highlights (PROS and CONS)
 */
@interface BVReviewHighlightsRequest : BVConversationsRequest

@property(nonnull, readonly) NSString *productId;

/// The id of the product for which review highlights are to be fetched
- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId;

- (nonnull instancetype)__unavailable init;

/// Make an asynch http request to fetch the review highlight's data.
/// BVReviewHighlightsResponse model for available fields.
- (void)load:(nonnull void (^)(BVReviewHighlightsResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;

@end
