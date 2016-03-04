//
//  BVRecommendationContinerProps.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 *  Miscellaenous properties use to configure the data that will be supplied in one of the recommendation containers, e.g. BVRecommendationsCarouselView
 */
@interface BVRecommendationContinerProps : NSObject

/**
 *
 *  The max number of recommendations returned for the container.
 *
 *  @availability 3.0.1 and later
 */
@property NSUInteger recommendationLimit;

/**
 *  Sets the max age (in seconds) of the recommenations API (BVGetShopperProfile). Note, this sets the cache duration for all requests to the BVGetShopperProfile API
 *
 * @availability 3.0.1 and later
 */
@property (assign, nonatomic) NSUInteger maxAgeCache;

/**
 *  Supply a product ID to provide recommendation context based on a current product being viewed.
 *  You need to provide a `productId` when either `mixerStrategies` or `categoryId` are supplied.
 *  The `productId` format is <client>/<id>, the value contained in `BVShopperProfile.productKey`.
 *
 *  @availability 3.0.1 and later
 */
@property (strong, nonatomic) NSString *productId;

/**
 *  Provide a category of product recommendations, related to the current product viewed. This value also requires setting the `productId`. The `categoryId` array is also supplied in a `BVProduct` object in the `category_ids` array.
 *
 *
 *  @availability 3.0.1 and later
 */
@property (strong, nonatomic) NSString *categoryId;

@end
