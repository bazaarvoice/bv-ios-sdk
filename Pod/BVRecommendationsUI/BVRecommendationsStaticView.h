//
//  BVRecommendationsStaticView.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVRecommendationUIProtocol.h"


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
 *  Delegate to style the product recommendation cells, react to errors, etc.
 */
@property (weak, nonatomic, nullable) id <BVRecommendationsUIDelegate> delegate;


/**
 *  Datasource providing list of user liked and user disliked products.
 */
@property (weak, nonatomic, nullable) id <BVRecommendationsUIDataSource> datasource;


/**
 *  Set the number of product recommendations to display in the BVRecommendationsStaticView.
 */
-(void)configureNumberOfRecommendations:(int)numberOfRecommendations;


@end