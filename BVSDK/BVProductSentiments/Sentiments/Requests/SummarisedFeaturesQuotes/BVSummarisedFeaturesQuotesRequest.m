//
//  BVSummarisedFeaturesQuotesRequest.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVSummarisedFeaturesQuotesRequest.h"
#import "BVCommaUtil.h"
#import "BVCommon.h"
#import "BVProductSentiments.h"
#import "BVProductSentimentsRequest.h"
#import "BVStringKeyValuePair.h"

@implementation BVSummarisedFeaturesQuotesRequest: BVProductSentimentsRequest

- (instancetype _Nonnull)initWithProductId:(NSString * _Nonnull)productId 
                                 featureId:(NSString * _Nonnull)featureId
                                  language:(NSString * _Nonnull)language
                                     limit:(NSUInteger)limit {
    if ((self = [super init])) {
        _productId = [BVCommaUtil escape:productId];
        _featureId = featureId;
        _language = language;
        _limit = limit;
    }
    return self;
}


- (nonnull NSString *)endpoint {
    return [NSString stringWithFormat:@"%@/%@/%@", @"summarised-features", self.featureId, @"quotes"];
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"productId" value:self.productId]];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"featureId" value:self.featureId]];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"language" value:self.language]];
  [params
      addObject:[BVStringKeyValuePair
                 pairWithKey:@"limit"
                 value:[NSString stringWithFormat:@"%i", (int)self.limit]]];
    
  return params;
}

- (void)load:(nonnull void (^)(BVSummarisedFeaturesQuotesResponse *__nonnull response))success
     failure:(nonnull ProductSentimentsFailureHandler)failure {
  // validate request
  if ([self.productId isEqualToString:@""] || [self.featureId isEqualToString:@""] || [self.language isEqualToString:@""]) {
    [self sendError:[self validationError] failureCallback:failure];
  } else if (1 > self.limit || 100 < self.limit) {
      // invalid request
    [self sendError:[super limitError:self.limit] failureCallback:failure];
  } else {
    [self loadSummarisedFeaturesQuotes:self completion:success failure:failure];
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
loadSummarisedFeaturesQuotes:(nonnull BVProductSentimentsRequest *)request
   completion:(nonnull void (^)(
                                BVSummarisedFeaturesQuotesResponse *__nonnull response))completion
      failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
      BVSummarisedFeaturesQuotesResponse *summarisedFeaturesQuotesResponse =
      [[BVSummarisedFeaturesQuotesResponse alloc]
                   initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(summarisedFeaturesQuotesResponse);
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
