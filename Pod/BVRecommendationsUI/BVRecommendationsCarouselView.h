//
//  BVRecommendationsCarouselView.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BVRecommendationUIProtocol.h"


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
 *  Delegate to style the product recommendation cells, react to errors, etc.
 */
@property (weak, nonatomic, nullable) id <BVRecommendationsUIDelegate> delegate;

/**
 *  Datasource providing list of user liked and user disliked products.
 */
@property (weak, nonatomic, nullable) id <BVRecommendationsUIDataSource> datasource;

-(void)reloadView;

@end
