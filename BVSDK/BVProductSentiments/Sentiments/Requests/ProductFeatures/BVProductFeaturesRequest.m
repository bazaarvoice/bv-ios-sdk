//
//  BVProductFeaturesRequest.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "BVProductFeaturesRequest.h"
#import "BVCommaUtil.h"
#import "BVCommon.h"
#import "BVProductSentiments.h"
#import "BVProductSentimentsRequest.h"
#import "BVStringKeyValuePair.h"

@implementation BVProductFeaturesRequest: BVProductSentimentsRequest

- (instancetype _Nonnull)initWithProductId:(NSString * _Nonnull)productId
                                  language:(NSString * _Nonnull)language
                                     limit:(NSUInteger)limit {
    if ((self = [super init])) {
      _productId = [BVCommaUtil escape:productId];
        _language = [BVCommaUtil escape:language];
        _limit = limit;
    }
    return self;
}


- (nonnull NSString *)endpoint {
    return @"features";
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"productId" value:self.productId]];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"language" value:self.language]];
  [params
      addObject:[BVStringKeyValuePair
                 pairWithKey:@"limit"
                 value:[NSString stringWithFormat:@"%i", (int)self.limit]]];
    
  return params;
}

- (void)load:(nonnull void (^)(BVProductFeaturesResponse *__nonnull response))success
     failure:(nonnull ProductSentimentsFailureHandler)failure {
  // validate request
  if ([self.productId isEqualToString:@""] || [self.language isEqualToString:@""]) {
    [self sendError:[self validationError] failureCallback:failure];
  } else if (1 > self.limit || 100 < self.limit) {
      // invalid request
    [self sendError:[super limitError:self.limit] failureCallback:failure];
  } else {
    [self loadProductFeatures:self completion:success failure:failure];
  }
}

- (nonnull NSError *)validationError {
  NSString *message = [NSString
      stringWithFormat:@"Invalid Request: Some parameter(s) have invalid value(s)"];
  return [NSError errorWithDomain:BVErrDomain
                             code:BV_ERROR_FIELD_INVALID
                         userInfo:@{NSLocalizedDescriptionKey : message}];
}

- (void)
loadProductFeatures:(nonnull BVProductSentimentsRequest *)request
   completion:(nonnull void (^)(
                                BVProductFeaturesResponse *__nonnull response))completion
      failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
      BVProductFeaturesResponse *productFeaturesResponse =
      [[BVProductFeaturesResponse alloc]
                   initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(productFeaturesResponse);
           });
                 [self sendProductSentimentsAnalytics];
         }
            failure:failure];
}

- (void)sendProductSentimentsAnalytics {
    // send usedfeature for product sentiments

    BVFeatureUsedEvent *event = [[BVFeatureUsedEvent alloc]
           initWithProductId:self.productId
                   withBrand:nil
             withProductType:BVPixelProductTypeProductSentiments
               withEventName:BVPixelFeatureUsedEventNameReviewHighlights
        withAdditionalParams:nil];

    [BVPixel trackEvent:event];
}

@end
