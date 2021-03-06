//
//  ProductDisplayPageRequest.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductDisplayPageRequest.h"
#import "BVBrand.h"
#import "BVCommaUtil.h"
#import "BVConversationsRequest+Private.h"
#import "BVPixel.h"
#import "BVProduct.h"
#import "BVProductFilterType.h"
#import "BVQuestion.h"
#import "BVRelationalFilterOperator.h"
#import "BVReview.h"
#import "BVStringKeyValuePair.h"

@interface BVProductDisplayPageRequest ()

@property(nonnull) NSString *productId;

@end

@implementation BVProductDisplayPageRequest

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId {
  if ((self = [super init])) {
    self.productId = [BVCommaUtil escape:productId];
  }
  return self;
}

- (void)load:(nonnull ProductRequestCompletionHandler)success
     failure:(nonnull ConversationsFailureHandler)failure {
  [self loadProducts:self completion:success failure:failure];
}

- (void)
loadProducts:(nonnull BVConversationsRequest *)request
  completion:
      (nonnull void (^)(BVProductsResponse *__nonnull response))completion
     failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
           BVProductsResponse *productsResponse =
               [[BVProductsResponse alloc] initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(productsResponse);
           });
           [self sendProductsAnalytics:productsResponse];

         }
            failure:failure];
}

- (void)sendProductsAnalytics:(BVProductsResponse *)productsResponse {
  BVProduct *product = productsResponse.result;
  if (product) {
    // send impressions for included content, reviews and questions

    for (BVReview *review in product.includedReviews) {
      NSString *brandName =
          review.product.brand ? review.product.brand.name : nil;
      BVImpressionEvent *reviewImpression = [[BVImpressionEvent alloc]
             initWithProductId:review.productId
                 withContentId:review.identifier
                withCategoryId:review.product.categoryId
               withProductType:BVPixelProductTypeConversationsReviews
               withContentType:BVPixelImpressionContentTypeReview
                     withBrand:brandName
          withAdditionalParams:nil];

      [BVPixel trackEvent:reviewImpression];
    }

    for (BVQuestion *question in product.includedQuestions) {
      // Record Question Impression
      BVImpressionEvent *questionImpression = [[BVImpressionEvent alloc]
             initWithProductId:question.productId
                 withContentId:question.identifier
                withCategoryId:question.categoryId
               withProductType:BVPixelProductTypeConversationsQuestionAnswer
               withContentType:BVPixelImpressionContentTypeQuestion
                     withBrand:nil
          withAdditionalParams:nil];

      [BVPixel trackEvent:questionImpression];
    }

    // send pageview for product
    NSString *brandName = product.brand ? product.brand.name : nil;
    BVPageViewEvent *pageView = [[BVPageViewEvent alloc]
             initWithProductId:product.identifier
        withBVPixelProductType:BVPixelProductTypeConversationsReviews
                     withBrand:brandName
                withCategoryId:product.categoryId
            withRootCategoryId:nil
          withAdditionalParams:nil];

    [BVPixel trackEvent:pageView];
  }
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];

  BVFilter *filter = [[BVFilter alloc]
      initWithFilterType:[BVProductFilterType filterTypeWithRawValue:
                                                  BVProductFilterValueProductId]
          filterOperator:[BVRelationalFilterOperator
                             filterOperatorWithRawValue:
                                 BVRelationalFilterOperatorValueEqualTo]
                  values:@[ self.productId ]];

  NSString *filterValue = [filter toParameterString];

  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"Filter" value:filterValue]];

  return params;
}

@end
