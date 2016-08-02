//
//  BVReviewCollectionViewCell.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVReview.h"

/**
 A sub-classed UICollectionView cell that contains one BVReview object for display.
 Clients should provide their one xib for the view.
 */
@interface BVReviewCollectionViewCell : UICollectionViewCell

/// The Conversations Reivew associated with this collectionViewCell
@property (strong, nonatomic) BVReview *review;

@end
