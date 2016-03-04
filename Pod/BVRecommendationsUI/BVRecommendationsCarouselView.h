//
//  BVRecommendationsCarouselView.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BVRecommendationUIProtocol.h"
#import "BVRecommendationContinerProps.h"

@protocol BVRecommendationsUIDelegate;
@protocol BVRecommendationsUIDataSource;

/**
 *  BVRecommendationsCarouselView is a UIView that creates a horizontally scrolling, single row UICollectionView
 *  that is populated with Bazaarvoice product recommendations automatically.
 */
@interface BVRecommendationsCarouselView : UIView

/**
 *  Left and right padding of the first and last cell of product recommendations, respectively.
 */
@property CGFloat leftAndRightPadding;

/**
 *  Top and bottom padding of the product recommendation cells.
 */
@property CGFloat topAndBottmPadding;

/**
 *  Spacing between each product recommendation cell.
 */
@property CGFloat cellHorizontalSpacing;

/**
 *  Properties you can configure for data/api control before setting the datasource property.
 */
@property (strong, nonatomic) BVRecommendationContinerProps * _Nonnull recommendationSettings;

/**
 *  Delegate to handle product view events, react to errors, etc.
 */
@property (weak, nonatomic, nullable) id <BVRecommendationsUIDelegate> delegate;

/**
 *  Provides the data requierments invoking the recommendations API as well as liked/banned product Ids.
 */
@property (weak, nonatomic, nullable) id <BVRecommendationsUIDataSource> datasource;

/**
 *  Force data to be reloaded from scratch
 */
-(void)reloadView;

/**
 *  Force the UI to be reloaded.
 */
-(void)refreshView;

@end
