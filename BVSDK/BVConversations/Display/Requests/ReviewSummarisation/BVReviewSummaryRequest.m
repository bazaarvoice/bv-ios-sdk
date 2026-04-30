//
//  BVReviewSummaryRequest.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVReviewSummaryRequest.h"
#import "BVCommaUtil.h"
#import "BVCommon.h"
#import "BVConversationsRequest+Private.h"
#import "BVLogger+Private.h"
#import "BVMonotonicSortOrder.h"
#import "BVPixel.h"
#import "BVQuestionsSortOption.h"
#import "BVRelationalFilterOperator.h"
#import "BVStringKeyValuePair.h"

@implementation BVReviewSummaryRequest

- (instancetype)initWithProductId:(NSString *)productId
                         language:(nonnull NSString *)language
                       formatType:(BVReviewSummaryFormatType)formatType {
    if ((self = [super init])) {
        _productId = [BVCommaUtil escape:productId];
        _language = language;
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
    // validate request
    if ([self.productId isEqualToString:@""]) {
        [self sendError:[self validationError:@"productId"] failureCallback:failure];
    } else if ([self.language isEqualToString:@""]) {
        [self sendError:[self validationError:@"language"] failureCallback:failure];
    } else {
        [self loadReviewSummary:self completion:success failure:failure];
    }
}

- (nonnull NSError *)validationError:(nullable NSString *)errorParam {
  NSString *message = [NSString
      stringWithFormat:@"Invalid Request: '%@' is required.", errorParam];
  return [NSError errorWithDomain:BVErrDomain
                             code:BV_ERROR_FIELD_INVALID
                         userInfo:@{NSLocalizedDescriptionKey : message}];
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
            if ([reviewSummaryResponse.status integerValue] == 200) {
                completion(reviewSummaryResponse);
            } else {                
                NSError *err = [NSError errorWithDomain:BVErrDomain
                                                   code:[reviewSummaryResponse.status integerValue]
                                               userInfo:@{ NSLocalizedDescriptionKey : reviewSummaryResponse.detail}];
                [self sendError:err failureCallback:failure];
            }
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
  [params
      addObject:[BVStringKeyValuePair pairWithKey:@"language" value:self.language]];
  NSString *format = [self formatTypeToString:(self.formatType)];
  [params
      addObject:[BVStringKeyValuePair
                    pairWithKey:@"formatType"
                 value:format]];
  return params;
}
    @end
    
    
