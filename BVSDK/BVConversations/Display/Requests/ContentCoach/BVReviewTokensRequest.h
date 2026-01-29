//
//  BVReviewTokensRequest.h
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

#ifndef BVReviewTokensRequest_h
#define BVReviewTokensRequest_h

#import "BVReviewTokensResponse.h"
#import "BVConversationDisplay.h"
#import "BVConversationsRequest.h"

@interface BVReviewTokensRequest : BVConversationsRequest

@property(nonnull, readonly) NSString *productId;

/// The id  for the review tokens you are trying to fetch
- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId;
- (nonnull instancetype)__unavailable init;

/// Make an asynch http request to fetch the Review Tokens profile data. See the
/// BVReviewTokens model for available fields.
- (void)load:(nonnull void (^)(BVReviewTokensResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;

@end

#endif /* BVReviewTokensRequest_h */
