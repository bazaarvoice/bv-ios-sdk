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
 *  When interacting with a BVRecommendationsUI component, this enum provides a list of features the user interacted with.
 */
typedef NS_ENUM(NSInteger, BVProductRecommendationWidget) {
    /**
     *  Product recommendations from a hoizontally scrolling carousel
     */
    RecommendationsCarousel = 0,
    /**
     *  Product recommendations from a stacked view of recommendations
     */
    RecommendationsStaticView,
    /**
     *  Product recommendations from a UITableViewController
     */
    RecommendationsTableView,
    /**
     *  Custom widget created.
     */
    RecommendationsCustom
};


/**
 *  Helper class wrapping BVAnalyticsManager that sends BVRecommendation and BVRecommendationUI analytic events.
 */
@interface BVRecsAnalyticsHelper : NSObject


+ (NSString *)getWidgetTypeString:(BVProductRecommendationWidget)widgetType;

/**
 *  Queue an analytic event for a visible BVProduct recommendation.
 *
 *  @param product A valid BVProduct object that was visible on screen.
 */
+(void)queueAnalyticsEventForProdctView:(BVProduct *)product;

/**
 *  Queue an analytic event for a user-interaction on a single-product view
 *
 *  @param product     A valid and visible project recommendation
 *  @param featureUsed The specific user-interaction
 */
+ (void)queueAnalyticsEventForProductFeatureUsed:(BVProduct *)product withFeatureUsed:(BVProductFeatureUsed)featureUsed withWidgetType:(BVProductRecommendationWidget)containerType;

/**
    Queue an analytic event for a recommendation widigit becoming visible on screen.
 
    @param productId - Product Id for the product. May be null. May not be combined with the category id.
    @param categoryId - Category Id used to fetch the recommendations. May be null, but not presented with the product id.
    @param clientId - The client Id used with the API call to fetch the recommendations.
    @param numRecommendations - The number of recommendations used to fill the widget
    @param widgetType - One of enum of BVProductRecommendationWidget
 
    @availability 3.0.1 and later
 
 */
+ (void)queueEmbeddedRecommendationsPageViewEvent:(NSString *)productId
                                   withCategoryId:(NSString *)categoryId
                                        withClientId:(NSString *)clientId
                           withNumRecommendations:(NSInteger)numRecommendations
                                   withWidgetType:(NSString *)widgetType;

/*
    Queue a view did scroll interaction event on a scrollable recommendations widget. This should only be sent once the view stops scrolling, in order to send too many events for every swipe.
 
    @param widghetType - One of enum of BVProductRecommendationWidget
 
    @availability 3.0.1 and later
 */
+ (void)queueAnalyticsEventForWidgetScroll:(BVProductRecommendationWidget)widgetType;

@end
