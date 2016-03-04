//
//  BVRecommendationUIProtocol.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#ifndef BVRecommendationUIProtocol_h
#define BVRecommendationUIProtocol_h

#import "BVRecommendations.h"
#import "BVRecommendationsUI.h"
#import "BVShopperProfile.h"
#import "BVRecommendationsSharedView.h"

/**
 *  Respond to events triggered by the recommendations UI.
 */
@protocol BVRecommendationsUIDelegate <NSObject>

@required


/**
 *  User tapped a product recommendation cell.
 */
- (void)didSelectProduct:(BVProduct *)product;


/**
 *  Product recommendations failed to load.
 */
- (void)didFailToLoadWithError:(NSError*)err;


@optional


/**
 *  Product recommendations successfully loaded.
 */
- (void)didLoadUserRecommendations:(BVShopperProfile *)profileRecommendations;


/**
 *  User toggled the `like` button.
 */
- (void)didToggleLike:(BVProduct *)product;


/**
 *  User toggled the `dislike` button.
 */
- (void)didToggleDislike:(BVProduct *)product;


/**
 *  User tapped the `shop now` button.
 */
- (void)didSelectShopNow:(BVProduct *)product;

@end






/**
 *  Provide data to the recommendations UI.
 */
@protocol BVRecommendationsUIDataSource <NSObject>

@optional


/**
 *  Describe the set of product ids that the user has `liked`. These product will be `liked` in the recommendations UI,
 *  if present in their product recommendations.
 */
- (NSMutableSet *)setForFavoriteProductIds;


/**
 *  Describe the set of product ids that the user has `disliked`. These product will be `disliked` in the recommendations UI,
 *  if present in their product recommendations.
 */
- (NSMutableSet *)setForBannedProductIds;

/**
 *  Configure the BVRecommendationsSharedView styling to your heart's desire. This method will be called once for each product recommendation cell in a recommendation container.
 */
- (void)styleRecommendationsView:(BVRecommendationsSharedView*)recommendationsView;

@end


#endif /* BVRecommendationUIProtocol_h */
