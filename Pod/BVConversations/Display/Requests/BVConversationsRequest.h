//
//  ConversationsRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVAuthorResponse.h"
#import "BVProductsResponse.h"
#import "BVReviewsResponse.h"
#import "BVStringKeyValuePair.h"

typedef void (^ConversationsFailureHandler)(
    NSArray<NSError *> *__nonnull errors);

/// Internal class - used only within BVSDK
@interface BVConversationsRequest : NSObject

- (nonnull NSMutableArray<BVStringKeyValuePair *> *)createParams;
- (nonnull NSString *)endpoint;
+ (nonnull NSString *)commonEndpoint;

- (nonnull instancetype)addAdditionalField:(nonnull NSString *)fieldName
                                     value:(nonnull NSString *)value
    __deprecated_msg("use addCustomDisplayParameter instead.");

/**
 This method adds extra user provided query parameters to a
 submission request, and will be urlencoded.
 */
- (nonnull instancetype)addCustomDisplayParameter:(nonnull NSString *)parameter
                                        withValue:(nonnull NSString *)value;

- (void)
loadContent:(nonnull BVConversationsRequest *)request
 completion:(nonnull void (^)(NSDictionary *__nonnull response))completion
    failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure;

- (void)sendError:(nonnull NSError *)error
    failureCallback:(nonnull ConversationsFailureHandler)failure;

- (void)sendErrors:(nonnull NSArray<NSError *> *)errors
    failureCallback:(nonnull ConversationsFailureHandler)failure;

- (nonnull NSError *)limitError:(NSInteger)limit;
- (nonnull NSError *)tooManyProductsError:
    (nonnull NSArray<NSString *> *)productIds;

- (nonnull NSString *)getPassKey;

@end
