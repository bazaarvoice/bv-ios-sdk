//
//  ConfirmViewController.h
//  PhotoUploadExample
//
//  Created by Bazaarvoice Engineering on 4/27/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//
//  UIViewController for displaying confirmation of review submission
//  to the user.

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface ConfirmViewController : UIViewController

// External property for passing the review data to this view
// controller
@property (strong, nonatomic) NSDictionary *confirmData;

// Image that was uploaded along with this review
@property (strong, nonatomic) UIImage *reviewImage;

// Review title, text, image and star rating displays
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UIImageView *reviewImageView;
@property (weak, nonatomic) IBOutlet RateView *rateView;

// Flash to indicate a successful submission
@property (weak, nonatomic) IBOutlet UIView *submitFlash;
@end
