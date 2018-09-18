//
//  BVReviewView.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReview.h"
#import <UIKit/UIKit.h>

/**
 A sub-classed UIView cell that contains one BVReview object for display.
 Clients should provide their one xib for the view.
 */

@interface BVReviewView : UIView

/// The Conversations Reivew associated with this view
@property(strong, nonatomic) BVReview *review;

@end
