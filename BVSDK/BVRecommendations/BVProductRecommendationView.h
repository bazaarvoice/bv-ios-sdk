//
//  BVProductRecommendationView.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@class BVRecommendedProduct;

/// A collection view cell to show a single product recommendation in.
/// This cell should be used in combination with
/// `BVRecommendationCollectionView`.
@interface BVRecommendationCollectionViewCell : UICollectionViewCell

/// The BVRecommendedProduct shown in this view
@property(strong, nonatomic) BVRecommendedProduct *bvRecommendedProduct;

@end

/// A table view cell to show a single product recommendation in.
/// This cell should be used in combination with `BVRecommendationTableView`.
@interface BVRecommendationTableViewCell : UITableViewCell

/// The BVRecommendedProduct shown in this view
@property(strong, nonatomic) BVRecommendedProduct *bvRecommendedProduct;

@end

/// A view to show a single product recommendation in.
/// This view may be used in combination with
/// `BVProductRecommendationsContainer`, which holds one or more of these views.
@interface BVProductRecommendationView : UIView

/// The BVRecommendedProduct shown in this view
@property(strong, nonatomic) BVRecommendedProduct *bvRecommendedProduct;

@end
