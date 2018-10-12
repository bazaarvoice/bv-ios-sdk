//
//  BVConversationsRequest+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVCONVERSATIONSREQUEST_PRIVATE_H
#define BVCONVERSATIONSREQUEST_PRIVATE_H

#import "BVConversationsRequest.h"
#import "BVStringKeyValuePair.h"

@interface BVConversationsRequest ()

- (nonnull NSMutableArray<BVStringKeyValuePair *> *)createParams;
- (nonnull NSString *)endpoint;
+ (nonnull NSString *)commonEndpoint;
- (nonnull NSString *)getPassKey;

- (nonnull NSError *)limitError:(NSInteger)limit;
- (nonnull NSError *)tooManyProductsError:
    (nonnull NSArray<NSString *> *)productIds;

- (void)sendError:(nonnull NSError *)error
    failureCallback:(nonnull ConversationsFailureHandler)failure;

- (void)sendErrors:(nonnull NSArray<NSError *> *)errors
    failureCallback:(nonnull ConversationsFailureHandler)failure;

@end

#endif /* BVCONVERSATIONSREQUEST_PRIVATE_H */
