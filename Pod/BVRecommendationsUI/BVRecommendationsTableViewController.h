//
//  BVRecommendationsTableViewController.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BVRecommendationUIProtocol.h"

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
 *  Delegate to style the product recommendation cells, react to errors, etc.
 */
@property (weak, nonatomic, nullable) id <BVRecommendationsUIDelegate> delegate;


/**
 *  Datasource providing list of user liked and user disliked products.
 */
@property (weak, nonatomic, nullable) id <BVRecommendationsUIDataSource> datasource;

@end
