//
//  BVCurationsAnalyticsHelper.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "BVCurationsFeedItem.h"

NS_ASSUME_NONNULL_BEGIN

/// Utility methods to assist in firing analytic events for the Curations product.
@interface BVCurationsAnalyticsHelper : NSObject

/// The types of containers that display curations feeds.
typedef NS_ENUM(NSInteger, BVCurationsFeedWidget) {
   
    /// Curations displayed in scrolling carousel
    BVCurationsFeedWidgetCarousel,
    
    /// Curations displayed in a UITableViewController
    BVCurationsFeedWidgetTableView,
    
    /// Custom widget created.
    BVCurationsFeedWidgetCustom,
    
    /// Curations displayed in scrolling grid
    BVCurationsFeedWidgetGrid
};


typedef NS_ENUM(NSInteger, BVCurationsSubmissionWidget) {
    BVCurationsSubmissionWidgetCompose,
    BVCurationsSubmissionWidgetCustom
};

/**
    Event used for when a particular Curations feed view is displayed on screen. Should only be called once after the container is created.
 
    @param widgetType The type of UIView subclass used to contain the feed.
    @param externalId This is the external Id used to make the API request for the Curations feed.
    @param widgetId The unique widget identifier for the UIView holding the BVCurationsCollectionViewCell objects. A default of "MainGrid" is supplied if not set. In the event you display > 1 BVCurationsCollectionView on a single UIViewController, the widgetId should be set as "SecondGrid", "ThridGrid", and so on.
 */
+ (void)queueUsedFeatureEventForContainerInView:(BVCurationsFeedWidget)widgetType withExternalId:(NSString *  _Nullable)externalId withWidgetId:(NSString * _Nullable)widgetId;


/**
    Event used when a Curations feed item appears on screen. This should only be fired once for a unique BVCuraitonsFeedItem object in a container.
 
    @parm feedItem The feed item cell that was was visible in the parent view.
 */
+ (void)queueUGCImpressionEventForFeedItem:(BVCurationsFeedItem *)feedItem;


/**
    Event used when a user taps anywhere on a paricular feed item.
 
    @parm feedItem The feed item cell that was tapped.
 */
+ (void)queueUsedFeatureEventForFeedItemTapped:(BVCurationsFeedItem *)feedItem;


/**
    Event used for to indicate that the user scrolled a conainer with a Curations feed. Typically this is fired on the first interaction with a UI container and when scrolling stops.
 
    @param widgetType The type of UIView subclass used to contain the feed.
    @param externalId This is the external Id used to make the API request for the Curations feed.
 */
+ (void)queueUsedFeatureEventForWidgetScroll:(BVCurationsFeedWidget)widgetType withExternalId:(NSString * _Nullable)externalId;


/**
    Event used for when a particular Curations feed view is created, but no necessarily displayed on screen.
 
    @param widgetType The type of UIView subclass used to contain the feed.
    @param externalId This is the external Id used to make the API request for the Curations feed.
 */
+ (void)queueEmbeddedPageViewEventCurationsFeed:(BVCurationsFeedWidget)widgetType withExternalId:(NSString * _Nullable)externalId;


/**
    Event used when a Curations submission view is displayed.
    
    @param widgetType The type of view used to submit curations content.
 */
+ (void)queueSubmissionPageView:(BVCurationsSubmissionWidget)widgetType;

/**
    Event used when a Curations content has been successfully posted.
 
    @param widgetType The type of view used to submit curations content.
 */
+ (void)queueUsedFeatureUploadPhoto:(BVCurationsSubmissionWidget)widgetType;

@end

NS_ASSUME_NONNULL_END
