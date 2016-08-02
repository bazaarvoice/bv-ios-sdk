//
//  BVReviewView.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVReview.h"


/**
 A sub-classed UIView cell that contains one BVReview object for display.
 Clients should provide their one xib for the view.
 */

@interface BVReviewView : UIView

/// The Conversations Reivew associated with this view
@property (strong, nonatomic) BVReview *review;


@end
