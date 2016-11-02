//
//  BVRecommendationsLoader.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "BVCore.h"
#import "BVShopperProfile.h"
#import "BVRecommendationsRequest.h"

NS_ASSUME_NONNULL_BEGIN


/// Loads product recommendations.
@interface BVRecommendationsLoader : NSObject


typedef void (^recommendationsCompletionHandler)(NSArray<BVRecommendedProduct*>*);
typedef void (^recommendationsErrorHandler)(NSError*);


/**
    Load product recommendations based on data fed in from `request`.
 
    @param request             The request parameters to load
    @param completionHandler   Completion handler which returns an array of `BVRecommendedProduct` product recommendations
    @param errorHandler        Error handler which returns an `NSError` if the request has failed.
 
    @availability 3.3.0 and later
 */
- (void)loadRequest:(BVRecommendationsRequest*)request
  completionHandler:(recommendationsCompletionHandler)completionHandler
       errorHandler:(recommendationsErrorHandler)errorHandler;

@end


NS_ASSUME_NONNULL_END
