//
//  ProductCell.h
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//
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
