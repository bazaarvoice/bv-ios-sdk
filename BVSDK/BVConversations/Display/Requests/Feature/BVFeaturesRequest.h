//
//  BVFeaturesRequest.h
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
//

#import "BVFeaturesResponse.h"
#import "BVConversationsRequest.h"

@interface BVFeaturesRequest : BVConversationsRequest

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId;
- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId language:(nonnull NSString *)language;
- (nonnull instancetype)__unavailable init;


/// Make an asynch http request to fetch the product features data. See the
/// BVFeaturesResponse model for available fields.
- (void)load:(nonnull void (^)(BVFeaturesResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;

@end
