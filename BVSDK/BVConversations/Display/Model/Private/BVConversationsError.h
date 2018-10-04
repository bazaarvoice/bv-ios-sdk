//
//  ConversationsError.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *__nonnull const BVKeyErrorMessage;
extern NSString *__nonnull const BVKeyErrorCode;

@interface BVConversationsError : NSObject

@property(nonnull) NSString *message;
@property(nonnull) NSString *code;

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;
- (nonnull NSError *)toNSError;
+ (nonnull NSArray<BVConversationsError *> *)createErrorListFromApiResponse:
    (nullable id)apiResponse;

@end
