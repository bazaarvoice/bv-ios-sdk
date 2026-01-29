//
//  BVReviewTokensRequest.m
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVReviewTokensRequest.h"
#import "BVCommaUtil.h"
#import "BVConversationsRequest+Private.h"
#import "BVLogger+Private.h"
#import "BVMonotonicSortOrder.h"
#import "BVPixel.h"
#import "BVQuestionsSortOption.h"
#import "BVRelationalFilterOperator.h"
#import "BVStringKeyValuePair.h"

@implementation BVReviewTokensRequest

- (instancetype)initWithProductId:(NSString *)productId {
    if ((self = [super init])) {
        _productId = [BVCommaUtil escape:productId];
    }
  return self;
}

- (void)load:(nonnull void (^)(BVReviewTokensResponse * _Nonnull __strong))success failure:(nonnull ConversationsFailureHandler)failure {
    [self loadReviewTokens:self completion:success failure:failure];
}

- (void)
loadReviewTokens:(nonnull BVConversationsRequest *)request
 completion:(nonnull void (^)(BVReviewTokensResponse *__nonnull response))completion
    failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
      BVReviewTokensResponse *reviewTokensResponse =
               [[BVReviewTokensResponse alloc] initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(reviewTokensResponse);
           });

           if (reviewTokensResponse && reviewTokensResponse.data) {
             [self sendReviewTokensAnalytics];
           }

         }
            failure:failure];
}

- (void)sendReviewTokensAnalytics {
    // send usedfeature for review tokens

    BVFeatureUsedEvent *event = [[BVFeatureUsedEvent alloc]
           initWithProductId:self.productId
                   withBrand:nil
             withProductType:BVPixelProductTypeConversationsProfile
               withEventName:BVPixelFeatureUsedEventNameReviewSummary
        withAdditionalParams:nil];

    [BVPixel trackEvent:event];
}

- (nonnull NSString *)endpoint {
    return @"reviewtokens";
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"productId" value:self.productId]];
  return params;
}
    @end
    
    
