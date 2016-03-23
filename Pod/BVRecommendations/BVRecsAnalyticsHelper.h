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
 *  When interacting with a BVRecommendationsUI component, this enum provides a list of container types the user interacted with.
 */
typedef NS_ENUM(NSInteger, BVProductRecommendationWidget) {
    /**
     *  Product recommendations from a hoizontally scrolling carousel
     */
    RecommendationsCarousel,
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

/*!
 Create and get the singleton instance of the analytics manager.
 */
+ (BVRecsAnalyticsHelper *)sharedManager;


+ (NSString *)getWidgetTypeString:(BVProductRecommendationWidget)widgetType;

/**
 *  Queue an analytic event for a visible BVProduct recommendation.
 *
 *  @param product A valid BVProduct object that was visible on screen.
 */
-(void)queueAnalyticsEventForProductView:(BVProduct *)product;

/**
 *  Queue an analytic event for a user tap on a product view
 *
 *  @param product     A valid and visible project recommendation
 */
- (void)queueAnalyticsEventForProductTapped:(BVProduct *)product;

/**
 *  Queue an analytic event for a recommendations widget being loaded
 *
 *  @param widgetType - One of enum of BVProductRecommendationWidget
 */
- (void)queueAnalyticsEventForRecommendationsOnPage:(BVProductRecommendationWidget)widgetType;

/**
    Queue an analytic event for a recommendation widigit becoming visible on screen.
 
    @param productId - Product Id for the product. May be null. May not be combined with the category id.
    @param categoryId - Category Id used to fetch the recommendations. May be null, but not presented with the product id.
    @param clientId - The client Id used with the API call to fetch the recommendations.
    @param numRecommendations - The number of recommendations used to fill the widget
    @param widgetType - One of enum of BVProductRecommendationWidget
 
    @availability 3.0.1 and later
 
 */
- (void)queueEmbeddedRecommendationsPageViewEvent:(NSString *)productId
                                   withCategoryId:(NSString *)categoryId
                           withNumRecommendations:(NSInteger)numRecommendations
                                   withWidgetType:(BVProductRecommendationWidget)widgetType;

/*
    Queue a view did scroll interaction event on a scrollable recommendations widget. This should only be sent once the view stops scrolling, in order to send too many events for every swipe.
 
    @param widghetType - One of enum of BVProductRecommendationWidget
 
    @availability 3.0.1 and later
 */
- (void)queueAnalyticsEventForWidgetScroll:(BVProductRecommendationWidget)widgetType;

@end
