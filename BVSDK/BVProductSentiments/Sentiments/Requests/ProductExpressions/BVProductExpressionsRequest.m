//
//  BVProductExpressionsRequest.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVProductExpressionsRequest.h"
#import "BVCommaUtil.h"
#import "BVCommon.h"
#import "BVProductSentiments.h"
#import "BVProductSentimentsRequest.h"
#import "BVStringKeyValuePair.h"

@implementation BVProductExpressionsRequest: BVProductSentimentsRequest

- (instancetype _Nonnull)initWithProductId:(NSString * _Nonnull)productId
                                   feature:(NSString * _Nonnull)feature
                                  language:(NSString * _Nonnull)language
                                     limit:(NSUInteger)limit {
    if ((self = [super init])) {
      _productId = [BVCommaUtil escape:productId];
        _feature = [BVCommaUtil escape:feature];
        _language = [BVCommaUtil escape:language];
        _limit = limit;
    }
    return self;
}


- (nonnull NSString *)endpoint {
    return @"expressions";
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"productId" value:self.productId]];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"feature" value:self.feature]];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"language" value:self.language]];
  [params
      addObject:[BVStringKeyValuePair
                 pairWithKey:@"limit"
                 value:[NSString stringWithFormat:@"%i", (int)self.limit]]];
    
  return params;
}

- (void)load:(nonnull void (^)(BVProductExpressionsResponse *__nonnull response))success
     failure:(nonnull ProductSentimentsFailureHandler)failure {
  // validate request
  if ([self.productId isEqualToString:@""] || [self.feature isEqualToString:@""] || [self.language isEqualToString:@""]) {
    [self sendError:[self validationError] failureCallback:failure];
  } else {
    [self loadProductExpressions:self completion:success failure:failure];
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
loadProductExpressions:(nonnull BVProductSentimentsRequest *)request
   completion:(nonnull void (^)(
                                BVProductExpressionsResponse *__nonnull response))completion
      failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
      BVProductExpressionsResponse *productExpressionsResponse =
      [[BVProductExpressionsResponse alloc]
                   initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(productExpressionsResponse);
           });
//           [self sendQuestionsAnalytics:questionsAndAnswersResponse];
         }
            failure:failure];
}



@end
