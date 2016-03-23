//
//  BVProductRecommendationView.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "BVProduct.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface BVRecommendationCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) BVProduct* bvProduct;

@end

@interface BVRecommendationTableViewCell : UITableViewCell

@property (strong, nonatomic) BVProduct* bvProduct;

@end

@interface BVProductRecommendationView : UIView

@property (strong, nonatomic) BVProduct* bvProduct;

@end