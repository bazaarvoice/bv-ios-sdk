//
//  BVProductExpressionsRequest.h
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#ifndef BVProductExpressionsRequest_h
#define BVProductExpressionsRequest_h

#import "BVProductSentiments.h"
#import "BVProductSentimentsRequest.h"
#import "BVProductExpressionsResponse.h"

@interface BVProductExpressionsRequest : BVProductSentimentsRequest

@property(nonnull, readonly) NSString *productId;
@property(nonnull, readonly) NSString *feature;
@property(nonnull, readonly) NSString *language;
@property(readonly) NSUInteger limit;

- (instancetype _Nonnull )initWithProductId:(NSString *_Nonnull)productId
                                    feature:(NSString *_Nonnull)feature
                                   language:(NSString *_Nonnull)language
                                      limit:(NSUInteger)limit;

- (void)load:(nonnull void (^)(
                               BVProductExpressionsResponse *__nonnull response))success
     failure:(nonnull ProductSentimentsFailureHandler)failure;
- (nonnull NSString *)endpoint;
- (nonnull NSMutableArray *)createParams;


@end

#endif /* BVProductExpressionsRequest_h */
