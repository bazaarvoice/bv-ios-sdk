//
//  BVProductQuotesRequest.h
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#ifndef BVProductQuotesRequest_h
#define BVProductQuotesRequest_h

#import "BVProductSentiments.h"
#import "BVProductSentimentsRequest.h"
#import "BVProductQuotesResponse.h"

@interface BVProductQuotesRequest : BVProductSentimentsRequest

@property(nonnull, readonly) NSString *productId;
@property(nonnull, readonly) NSString *language;
@property(readonly) NSUInteger limit;

- (instancetype _Nonnull )initWithProductId:(NSString *_Nonnull)productId
                                  language:(NSString *_Nonnull)language
                                      limit:(NSUInteger)limit;

- (void)load:(nonnull void (^)(
                               BVProductQuotesResponse *__nonnull response))success
     failure:(nonnull ProductSentimentsFailureHandler)failure;
- (nonnull NSString *)endpoint;
- (nonnull NSMutableArray *)createParams;


@end

#endif /* BVProductQuotesRequest_h */
