//
//  BVQuestionCollectionViewCell.h
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVQuestion.h"

/**
 A sub-classed UICollectionView cell that contains one BVQuestion object for display.
 Clients should provide their one xib for the view.
 */
@interface BVQuestionCollectionViewCell : UICollectionViewCell

/// The Conversations Question associated with this collectionViewCell
@property (strong, nonatomic) BVQuestion *question;

@end
