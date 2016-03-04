//
//  BVRecommendationsTableViewController.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BVRecommendationUIProtocol.h"
#import "BVRecommendationContinerProps.h"

@protocol BVRecommendationsUIDelegate;
@protocol BVRecommendationsUIDataSource;

typedef NS_ENUM(NSInteger, BVProductCellType){
    BVProductCellTypeLarge,
    BVProductCellTypeSmall
};



/**
 *  BVRecommendationsTableViewController is a full UITableViewController that is automatically populated
 *  with Bazaarvoice product recommendations.
 */
@interface BVRecommendationsTableViewController : UITableViewController

@property (nonatomic) BVProductCellType cellType;


/**
 *  Configure the `loading` indicator.
 */
@property (strong, nonatomic, nullable) NSString* progressWheelText;
@property (strong, nonatomic, nullable) UIColor* progressWheelColor;
@property (strong, nonatomic, nullable) UIColor* progressWheelBackgroundColor;

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
