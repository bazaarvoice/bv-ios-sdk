//
//  ConversationsError.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BVKeyErrorDomainCode @(999)

extern NSString *__nonnull const BVKeyErrorCode;
extern NSString *__nonnull const BVKeyErrorMessage;

@interface BVConversationsError : NSObject

@property(nonnull) NSString *message;
@property(nonnull) NSString *code;
@property(nonnull) NSString *field;

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;
- (nonnull NSError *)toNSError;
+ (nonnull NSArray<BVConversationsError *> *)createErrorListFromApiResponse:
    (nullable id)apiResponse;

@end
