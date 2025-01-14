//
//  BVReviewSummaryRequest.h
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#ifndef BVReviewSummaryRequest_h
#define BVReviewSummaryRequest_h

#import "BVReviewSummaryResponse.h"
#import "BVConversationDisplay.h"
#import "BVConversationsRequest.h"
#import "BVReviewSummaryFormatTypeValue.h"

/** This class allow you to build request parameters and request a user profile
 * (author) and accepted content (Reviews, Questions, Answers) the author has
 * submitted. The request builder conforms to parameters described in
 * https://developer.bazaarvoice.com/docs/read/conversations_api/reference/latest/profiles/display#parameters
 */



@interface BVReviewSummaryRequest : BVConversationsRequest

@property(nonnull, readonly) NSString *productId;
@property BVReviewSummaryFormatType formatType;

/// The id and format  for the review summary you are trying to fetch
- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                               formatType:(BVReviewSummaryFormatType)formatType;
- (nonnull instancetype)__unavailable init;

/// Make an asynch http request to fetch the Author's profile data. See the
/// BVAuthorResponse model for available fields.
- (void)load:(nonnull void (^)(BVReviewSummaryResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;

@end

#endif /* BVReviewSummaryRequest_h */
