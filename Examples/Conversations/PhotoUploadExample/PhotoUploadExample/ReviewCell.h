//
//  ReviewCell.h
//  Bazaarvoice SDK - Photo Upload Example Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//
//
//  Custom UITableViewCell for displaying a review

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface ReviewCell : UITableViewCell

// UIViews for visual representation of a review
@property (nonatomic, weak) IBOutlet UILabel *author;
@property (nonatomic, weak) IBOutlet UITextView *review;
@property (nonatomic, weak) IBOutlet RateView *stars;

@end
