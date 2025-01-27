//
//  BVSummarisedFeaturesRequest.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#ifndef BVSummarisedFeaturesRequest_h
#define BVSummarisedFeaturesRequest_h

#import "BVProductSentiments.h"
#import "BVProductSentimentsRequest.h"
#import "BVSummarisedFeaturesResponse.h"

@interface BVSummarisedFeaturesRequest : BVProductSentimentsRequest

@property(nonnull, readonly) NSString *productId;
@property(nonnull, readonly) NSString *language;
@property(nullable, readonly) NSString *embed;

- (instancetype _Nonnull )initWithProductId:(NSString *_Nonnull)productId
                         language:(NSString *_Nonnull)language
                            embed:(NSString *_Nullable)embed;

- (void)load:(nonnull void (^)(
                               BVSummarisedFeaturesResponse *__nonnull response))success
     failure:(nonnull ProductSentimentsFailureHandler)failure;
- (nonnull NSString *)endpoint;
- (nonnull NSMutableArray *)createParams;


@end

#endif /* BVSummarisedFeaturesRequest_h */
