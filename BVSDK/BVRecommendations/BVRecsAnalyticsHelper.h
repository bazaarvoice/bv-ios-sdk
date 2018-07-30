

//
//  BVRecsAnalyticsHelper.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVRecommendationsLoader.h"
#import "BVShopperProfile.h"
#import <Foundation/Foundation.h>

@class BVRecommendationsLoader;

/// When interacting with a BVRecommendationsUI component, this enum provides a
/// list of container types the user interacted with.
typedef NS_ENUM(NSInteger, BVProductRecommendationWidget) {

    /// Product recommendations from a horizontally scrolling collection view.
    RecommendationsCarousel,

    /// Product recommendations from a UITableView
    RecommendationsTableView,

    /// Custom widget created.
    RecommendationsCustom

};

/// Used to send analytic events related to product recommendations
@interface BVRecsAnalyticsHelper : NSObject

/**
    Queue an analytic event for a user tapping on a product view

    @param product - The product that was tapped by the user
 */
+ (void)queueAnalyticsEventForProductTapped:(BVRecommendedProduct *)product;

/**
    Queue an analytic event for a recommendations widget being loaded

    @param widgetType - Type of widget that was loaded
 */
+ (void)queueAnalyticsEventForRecommendationsOnPage:
    (BVProductRecommendationWidget)widgetType;

/**
 Queue an analytic event for a recommendation widigit becoming visible on
 screen.

 @param recommendationsRequest - The BVRecommendationsRequest use to
 construct the request parameters
 @param pageType - The class of the page view object presenting
 @param widgetType - One of enum of BVProductRecommendationWidget

 @availability 3.0.1 and later
 */
+ (void)queueEmbeddedRecommendationsPageViewEvent:
            (BVRecommendationsRequest *)recommendationsRequest
                                         pageType:(Class)pageType
                                   withWidgetType:
                                       (BVProductRecommendationWidget)
                                           widgetType;

/**
    Queue an analytic event for a recommendation widigit becoming visible on
   screen.

    @param recommendationsRequest - The BVRecommendationsRequest use to
   construct the request parameters
    @param widgetType - One of enum of BVProductRecommendationWidget

    @availability 3.0.1 and later
    @deprecated please use the pageType variant
 */
+ (void)queueEmbeddedRecommendationsPageViewEvent:
            (BVRecommendationsRequest *)recommendationsRequest
                                   withWidgetType:
                                       (BVProductRecommendationWidget)widgetType
    __attribute__((deprecated));

/*
    Queue a view did scroll interaction event on a scrollable recommendations
   widget. This should only be sent once the view stops scrolling, in order to
   send too many events for every swipe.

    @param widgetType - One of enum of BVProductRecommendationWidget

    @availability 3.0.1 and later
 */
+ (void)queueAnalyticsEventForWidgetScroll:
    (BVProductRecommendationWidget)widgetType;

@end
