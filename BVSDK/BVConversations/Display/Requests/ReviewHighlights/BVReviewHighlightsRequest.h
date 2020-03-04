//
//  BVReviewHighlightsRequest.h
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import "BVReviewHighlightsResponse.h"
#import "BVConversationsRequest.h"

/** This class allow you to build request parameters and request a user profile
 * (reviewHighlight) and accepted content (productId)
 */
@interface BVReviewHighlightsRequest : BVConversationsRequest

@property(nonnull, readonly) NSString *productId;

/// The details (reviewHighlights) of the product you are trying to fetch
- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId;

- (nonnull instancetype)__unavailable init;

/// Make an asynch http request to fetch the Author's profile data.
/// BVReviewHighlightsResponse model for available fields.
- (void)load:(nonnull void (^)(BVReviewHighlightsResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;

@end
