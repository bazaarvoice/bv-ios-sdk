//
//  ReviewDetailViewController.h
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//
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
