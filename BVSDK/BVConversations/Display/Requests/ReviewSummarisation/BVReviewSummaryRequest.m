//
//  BVReviewSummaryRequest.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVReviewSummaryRequest.h"
#import "BVCommaUtil.h"
#import "BVConversationsRequest+Private.h"
#import "BVLogger+Private.h"
#import "BVMonotonicSortOrder.h"
#import "BVPixel.h"
#import "BVQuestionsSortOption.h"
#import "BVRelationalFilterOperator.h"
#import "BVStringKeyValuePair.h"

@implementation BVReviewSummaryRequest

- (instancetype)initWithProductId:(NSString *)productId
                       formatType:(BVReviewSummaryFormatType)formatType {
    if ((self = [super init])) {
        _productId = [BVCommaUtil escape:productId];
        _formatType = formatType;
    }
  return self;
}


- (NSString*)formatTypeToString:(BVReviewSummaryFormatType)formatType {
    NSString *result = nil;

    switch(formatType) {
        case BVBullet:
            result = @"bullet";
            break;
        case BVParagraph:
            result = @"paragraph";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }

    return result;
}

- (void)load:(nonnull void (^)(BVReviewSummaryResponse * _Nonnull __strong))success failure:(nonnull ConversationsFailureHandler)failure {
    [self loadReviewSummary:self completion:success failure:failure];
}

- (void)
loadReviewSummary:(nonnull BVConversationsRequest *)request
 completion:(nonnull void (^)(BVReviewSummaryResponse *__nonnull response))completion
    failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
      BVReviewSummaryResponse *reviewSummaryResponse =
               [[BVReviewSummaryResponse alloc] initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(reviewSummaryResponse);
           });

           if (reviewSummaryResponse && reviewSummaryResponse.summary) {
             [self sendReviewSummaryAnalytics];
           }

         }
            failure:failure];
}

- (void)sendReviewSummaryAnalytics {
    // send usedfeature for review summary

    BVFeatureUsedEvent *event = [[BVFeatureUsedEvent alloc]
           initWithProductId:self.productId
                   withBrand:nil
             withProductType:BVPixelProductTypeConversationsProfile
               withEventName:BVPixelFeatureUsedEventNameReviewSummary
        withAdditionalParams:nil];

    [BVPixel trackEvent:event];
}

- (nonnull NSString *)endpoint {
    return @"reviewsummary";
}



- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"productId" value:self.productId]];
    NSString *format = [self formatTypeToString:(self.formatType)];

  [params
      addObject:[BVStringKeyValuePair
                    pairWithKey:@"formatType"
                 value:format]];
  return params;
}
    @end
    
    
