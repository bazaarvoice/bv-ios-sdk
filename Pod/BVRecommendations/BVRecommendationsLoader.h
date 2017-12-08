//
//  BVRecommendationsLoader.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVCommon.h"
#import "BVRecommendationsRequest.h"
#import "BVShopperProfile.h"

/// Loads product recommendations.
@interface BVRecommendationsLoader : NSObject

typedef void (^recommendationsCompletionHandler)(
    NSArray<BVRecommendedProduct *> *__nonnull);
typedef void (^recommendationsErrorHandler)(NSError *__nonnull);

/**
    Load product recommendations based on data fed in from `request`.

    @param request             The request parameters to load
    @param completionHandler   Completion handler which returns an array of
   `BVRecommendedProduct` product recommendations
    @param errorHandler        Error handler which returns an `NSError` if the
   request has failed.

    @availability 3.3.0 and later
 */
- (void)loadRequest:(nullable BVRecommendationsRequest *)request
    completionHandler:
        (nullable recommendationsCompletionHandler)completionHandler
         errorHandler:(nullable recommendationsErrorHandler)errorHandler;

@end
