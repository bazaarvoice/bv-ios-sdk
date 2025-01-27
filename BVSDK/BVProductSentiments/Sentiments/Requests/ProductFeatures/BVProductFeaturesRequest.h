//
//  BVProductFeaturesRequest.h
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#ifndef BVProductFeaturesRequest_h
#define BVProductFeaturesRequest_h

#import "BVProductSentiments.h"
#import "BVProductSentimentsRequest.h"
#import "BVProductFeaturesResponse.h"

@interface BVProductFeaturesRequest : BVProductSentimentsRequest

@property(nonnull, readonly) NSString *productId;
@property(nonnull, readonly) NSString *language;
@property(readonly) NSUInteger limit;

- (instancetype _Nonnull )initWithProductId:(NSString *_Nonnull)productId
                                  language:(NSString *_Nonnull)language
                                      limit:(NSUInteger)limit;

- (void)load:(nonnull void (^)(
                               BVProductFeaturesResponse *__nonnull response))success
     failure:(nonnull ProductSentimentsFailureHandler)failure;
- (nonnull NSString *)endpoint;
- (nonnull NSMutableArray *)createParams;


@end

#endif /* BVProductFeaturesRequest_h */
