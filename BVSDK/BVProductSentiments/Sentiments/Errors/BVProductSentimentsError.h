//
//  BVProductSentimentsError.h
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#ifndef BVProductSentimentsError_h
#define BVProductSentimentsError_h

#import <Foundation/Foundation.h>

#define BVKeyPSErrorDomainCode @(999)

extern NSString *__nonnull const BVKeyPSStatusCode;
extern NSString *__nonnull const BVKeyPSErrorCode;
extern NSString *__nonnull const BVKeyPSErrorMessage;

@interface BVProductSentimentsError : NSObject

@property(nonnull) NSString *message;
@property(nonnull) NSString *code;
@property(nonnull) NSString *status;

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse
                       statusCode:(nonnull NSString *) statusCode;
- (nonnull NSError *)toNSError;

@end


#endif /* BVProductSentimentsError_h */
