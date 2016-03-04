//
//  BVRecommendationsStaticView.h
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
 *  BVRecommendationsStaticView is a non-scrolling UIView that displays a set number of product recommendations.
 *  After creating a BVRecommendationsStaticView instance, call `configureNumberOfRecommendations:` to set the
 *  desired number of recommendations to display. This number defaults to 3.
 */
@interface BVRecommendationsStaticView : UIView


/**
 *  Desired padding around the content of the cells.
 */
@property CGFloat cellPadding;

/**
 *  Color of the cell separator line.
 */
@property (strong, nonatomic, nonnull) UIColor* separatorColor;


/**
 *  Delegate to handle product view events, react to errors, etc.
 */
@property (weak, nonatomic, nullable) id <BVRecommendationsUIDelegate> delegate;

/**
 *  Provides the data requierments invoking the recommendations API as well as liked/banned product Ids.
 */
@property (weak, nonatomic, nullable) id <BVRecommendationsUIDataSource> datasource;

/**
 *  Properties you can configure for data/api control before setting the datasource property.
 */
@property (strong, nonatomic) BVRecommendationContinerProps * _Nonnull recommendationSettings;

/**
 *  Force data to be reloaded from scratch
 */
-(void)reloadView;

/**
 *  Force the UI to be reloaded.
 */
-(void)refreshView;

@end