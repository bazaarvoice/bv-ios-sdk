//
//  BVCurationsCollectionViewCell.h
//  Bazaarvoice SDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVCurationsFeedItem.h"

/// A UICollectionViewCell that contains one BVCurationsFeedItem object. Clients should subclass this and add their own UI outlets. Used in combination with `BVCurationsCollectionView`
@interface BVCurationsCollectionViewCell : UICollectionViewCell

/*!
  The BVCurationsFeedItem used to fill out the UI
 */
@property (strong, nonatomic) BVCurationsFeedItem *feedItem;

@end
