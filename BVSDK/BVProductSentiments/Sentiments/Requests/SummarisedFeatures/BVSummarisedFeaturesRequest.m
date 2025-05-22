//
//  BVSummarisedFeaturesRequest.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVSummarisedFeaturesRequest.h"
#import "BVCommaUtil.h"
#import "BVCommon.h"
#import "BVProductSentiments.h"
#import "BVProductSentimentsRequest.h"
#import "BVStringKeyValuePair.h"

@implementation BVSummarisedFeaturesRequest: BVProductSentimentsRequest

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                                 language:(nonnull NSString *)language
                                 embed:(nullable NSString *)embed {
    if ((self = [super init])) {
        _productId = [BVCommaUtil escape:productId];
        _language = language;
        if ([embed length] > 0) {
            _embed = embed;
        }
    }
  return self;
}


- (nonnull NSString *)endpoint {
  return @"summarised-features";
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"productId" value:self.productId]];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"language" value:self.language]];
    if (!([self.embed  isEqualToString: @""])) {
        [params
            addObject:[BVStringKeyValuePair pairWithKey:@"embed" value:self.embed]];
    }
  return params;
}

- (void)load:(nonnull void (^)(BVSummarisedFeaturesResponse *__nonnull response))success
     failure:(nonnull ProductSentimentsFailureHandler)failure {
  // validate request
  if ([self.productId isEqualToString:@""] || [self.language isEqualToString:@""]) {
    [self sendError:[self validationError] failureCallback:failure];
  } else {
    [self loadSummarisedFeatures:self completion:success failure:failure];
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
loadSummarisedFeatures:(nonnull BVProductSentimentsRequest *)request
   completion:(nonnull void (^)(
                  BVSummarisedFeaturesResponse *__nonnull response))completion
      failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
      BVSummarisedFeaturesResponse *summarisedFeaturesResponse =
               [[BVSummarisedFeaturesResponse alloc]
                   initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(summarisedFeaturesResponse);
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
