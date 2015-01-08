//
//  ProductCell.h
//  RateAndReviewExample
//
//  Created by Bazaarvoice Engineering on 4/23/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//
//  Custom UITableViewCell for displaying a product


#import <UIKit/UIKit.h>
#import "StarRatingView.h"

@interface ProductCell : UITableViewCell

// UIViews for visual representation of a product
@property (weak) IBOutlet UILabel *title;
@property (weak) IBOutlet UILabel *description;
@property (weak) IBOutlet StarRatingView *stars;

@end
