//
//  BVReviewCollectionViewCell.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReview.h"
#import <UIKit/UIKit.h>

/**
 A sub-classed UICollectionView cell that contains one BVReview object for
 display. Clients should provide their one xib for the view.
 */
@interface BVReviewCollectionViewCell : UICollectionViewCell

/// The Conversations Reivew associated with this collectionViewCell
@property(strong, nonatomic) BVReview *review;

@end
