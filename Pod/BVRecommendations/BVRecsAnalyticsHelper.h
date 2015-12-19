//
//  BVRecsAnalyticsHelper.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVAnalyticsManager.h"
#import "BVShopperProfile.h"

/**
 *  When interacting with a BVRecommendationsUI component, this enum provides a list of features the user interacted with.
 */
typedef NS_ENUM(NSInteger, BVProductFeatureUsed) {
    /**
     *  Use tapped like
     */
    TapLike = 0,
    /**
     *  User tapped dislike (ban)
     */
    TapUnlike,
    /**
     *  User tapped the shop now button
     */
    TapShopNow,
    /**
     *  User tapped the ratings and reviews widget
     */
    TapRatingsReviews,
    /**
     *  User tapped on the product
     */
    TapProduct
};

/**
 *  Helper class wrapping BVAnalyticsManager that sends BVRecommendation and BVRecommendationUI analytic events.
 */
@interface BVRecsAnalyticsHelper : NSObject

/**
 *  Provided a BVShopperProfile object, logs an anonymous analytic event for the provided recommendations.
 *
 *  @param profile A valid BVShopperProfile object
 */
+(void)createAnalyticsRecommendationEventFromProfile:(BVShopperProfile *)profile;

/**
 *  Queue an analytic event for a visible BVProduct recommendation.
 *
 *  @param product A valid BVProduct object that was visible on screen.
 */
+(void)queueAnalyticsEventForProdctView:(BVProduct *)product;

/**
 *  Queue an analytic event for a user-interaction
 *
 *  @param product     A valid and visible project recommendation
 *  @param featureUsed The specific user-interaction
 */
+ (void)queueAnalyticsEventForProductFeatureUsed:(BVProduct *)product withFeatureUsed:(BVProductFeatureUsed)featureUsed;

@end
