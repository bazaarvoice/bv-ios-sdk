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

/** This class allow you to build request parameters and request a user profile
 * (author) and accepted content (Reviews, Questions, Answers) the author has
 * submitted. The request builder conforms to parameters described in
 * https://developer.bazaarvoice.com/docs/read/conversations_api/reference/latest/profiles/display#parameters
 */

@interface BVReviewTokensRequest : BVConversationsRequest

@property(nonnull, readonly) NSString *productId;

/// The id  for the review tokens you are trying to fetch
- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId;
- (nonnull instancetype)__unavailable init;

/// Make an asynch http request to fetch the Author's profile data. See the
/// BVAuthorResponse model for available fields.
- (void)load:(nonnull void (^)(BVReviewTokensResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;

@end

#endif /* BVReviewTokensRequest_h */
