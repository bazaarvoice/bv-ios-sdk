//
//  BVSummarisedFeaturesQuotesRequest.h
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#ifndef BVSummarisedFeaturesQuotesRequest_h
#define BVSummarisedFeaturesQuotesRequest_h

#import "BVProductSentiments.h"
#import "BVProductSentimentsRequest.h"
#import "BVSummarisedFeaturesQuotesResponse.h"

@interface BVSummarisedFeaturesQuotesRequest : BVProductSentimentsRequest

@property(nonnull, readonly) NSString *productId;
@property(nonnull, readonly) NSString *featureId;
@property(nonnull, readonly) NSString *language;
@property(readonly) NSUInteger limit;

- (instancetype _Nonnull )initWithProductId:(NSString *_Nonnull)productId
                                  featureId:(NSString *_Nonnull)featureId
                                  language:(NSString *_Nonnull)language
                                      limit:(NSUInteger)limit;

- (void)load:(nonnull void (^)(
                               BVSummarisedFeaturesQuotesResponse *__nonnull response))success
     failure:(nonnull ProductSentimentsFailureHandler)failure;
- (nonnull NSString *)endpoint;
- (nonnull NSMutableArray *)createParams;


@end


#endif /* BVSummarisedFeaturesQuotesRequest_h */
