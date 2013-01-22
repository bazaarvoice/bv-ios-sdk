//
//  ReviewDetailViewController.h
//  BrowseProductsExample
//
//  Created by Bazaarvoice Engineering on 4/25/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//
//  UIViewController for displaying a specific review

#import <UIKit/UIKit.h>
#import "StarRatingView.h"

@interface ReviewDetailViewController : UIViewController

// External property for passing review data to this review controller
@property (nonatomic, strong) NSDictionary *reviewData;

// Review display information
@property (weak, nonatomic) IBOutlet UITextView *review;
@property (weak, nonatomic) IBOutlet UILabel *reviewTitle;
@property (weak, nonatomic) IBOutlet StarRatingView *starRating;
@property (weak, nonatomic) IBOutlet UIImageView *reviewImage;

@end
