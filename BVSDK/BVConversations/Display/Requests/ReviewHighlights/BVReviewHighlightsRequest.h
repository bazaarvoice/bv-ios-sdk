//
//  BVReviewHighlightsRequest.h
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import "BVReviewHighlightsResponse.h"
#import "BVConversationsRequest.h"

@interface BVReviewHighlightsRequest : NSObject

@property(nonnull, readonly) NSString *productId;

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId;

- (nonnull instancetype)__unavailable init;

- (void)load:(nonnull void (^)(BVReviewHighlightsResponse *__nonnull response))success
failure:(nonnull ConversationsFailureHandler)failure;

@end
