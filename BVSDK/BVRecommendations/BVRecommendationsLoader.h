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

typedef void (^recommendationsCompletionHandler)(
    NSArray<BVRecommendedProduct *> *__nonnull);
typedef void (^recommendationsErrorHandler)(NSError *__nonnull);

/// Loads product recommendations.
@interface BVRecommendationsLoader : NSObject

/**
    Purges the internal cache of the BVRecommendation Engine.

    @availability 3.3.0 and later
 */
+ (void)purgeRecommendationsCache;

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
