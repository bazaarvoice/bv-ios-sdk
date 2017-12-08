//
//  BVReviewsTableViewCells.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReview.h"
#import <UIKit/UIKit.h>

/**
 A sub-classed UITableViewCell cell that contains one BVReview object for
 display. Clients should provide their one xib for the view.
 */
@interface BVReviewTableViewCell : UITableViewCell

/// The Conversations Reivew associated with this tableViewCell
@property(strong, nonatomic) BVReview *review;

@end
