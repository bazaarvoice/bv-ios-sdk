//
//  BVProductSentimentsRequest.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#ifndef BVProductSentimentsRequest_h
#define BVProductSentimentsRequest_h

#import <Foundation/Foundation.h>
#import "BVProductSentiments.h"

@class BVStringKeyValuePair;
@interface BVProductSentimentsRequest : NSObject

- (nonnull NSMutableArray<BVStringKeyValuePair *> *)createParams;
- (nonnull NSString *)endpoint;
+ (nonnull NSString *)commonEndpoint;
- (nonnull NSString *)getPassKey;

- (nonnull NSError *)limitError:(NSInteger)limit;
- (nonnull NSError *)tooManyProductsError:
    (nonnull NSArray<NSString *> *)productIds;

- (void)
loadContent:(nonnull BVProductSentimentsRequest *)request
 completion:(nonnull void (^)(NSDictionary *__nonnull response))completion
    failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure;

- (void)sendError:(nonnull NSError *)error
  failureCallback:(nonnull ProductSentimentsFailureHandler)failure;

- (void)sendErrors:(nonnull NSArray<NSError *> *)errors
   failureCallback:(nonnull ProductSentimentsFailureHandler)failure;

@end

#endif /* BVProductSentimentsRequest_h */
