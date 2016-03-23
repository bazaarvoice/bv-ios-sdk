//
//  BVProductRecommendationsContainer.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "BVRecommendations.h"

@class BVGetShopperProfile;

@interface BVProductRecommendationsContainer : UIView

@property BVGetShopperProfile* profile;

@end

@interface BVProductRecommendationsTableView : UITableView

@property BVGetShopperProfile* profile;

@end

@interface BVProductRecommendationsCollectionView : UICollectionView

@property BVGetShopperProfile* profile;

@end