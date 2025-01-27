//
//  BVProductQuotesRequest.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVProductQuotesRequest.h"
#import "BVCommaUtil.h"
#import "BVCommon.h"
#import "BVProductSentiments.h"
#import "BVProductSentimentsRequest.h"
#import "BVStringKeyValuePair.h"

@implementation BVProductQuotesRequest: BVProductSentimentsRequest

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
    return @"quotes";
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

- (void)load:(nonnull void (^)(BVProductQuotesResponse *__nonnull response))success
     failure:(nonnull ProductSentimentsFailureHandler)failure {
  // validate request
  if ([self.productId isEqualToString:@""] || [self.language isEqualToString:@""]) {
    [self sendError:[self validationError] failureCallback:failure];
  } else {
    [self loadProductQuotes:self completion:success failure:failure];
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
loadProductQuotes:(nonnull BVProductSentimentsRequest *)request
   completion:(nonnull void (^)(
                                BVProductQuotesResponse *__nonnull response))completion
      failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
      BVProductQuotesResponse *productQuotesResponse =
      [[BVProductQuotesResponse alloc]
                   initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(productQuotesResponse);
           });
//           [self sendQuestionsAnalytics:questionsAndAnswersResponse];
         }
            failure:failure];
}



@end
