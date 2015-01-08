//
//  ConfirmViewController.m
//  PhotoUploadExample
//
//  Created by Bazaarvoice Engineering on 4/27/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//

#import "ConfirmViewController.h"
#import "NSDictionary+Utils.h"
#import "ReviewCell.h"


@implementation ConfirmViewController
@synthesize submitFlash = _submitFlash;
@synthesize rateView = _rateView;
@synthesize reviewTextView = _reviewTextView;
@synthesize reviewImageView = _reviewImage;
@synthesize confirmData = _confirmData;
@synthesize reviewImage = _previewImage;
@synthesize titleLabel = _titleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // RateView setup.  Note that in this case, we are merely displaying
    // the star rating, so it is not editable
    self.rateView.notSelectedImage = [UIImage imageNamed:@"empty_star.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"full_star.png"];
    self.rateView.rating = 0;
    self.rateView.editable = NO;
    self.rateView.maxRating = 5;
    
    [self setUpReviewDisplay];
}


- (void)setUpReviewDisplay
{
    // Set up the review display for the title, text and rating
    NSDictionary *reviewData = [self.confirmData objectForKeyNotNull:@"Review"];
    self.titleLabel.text = [reviewData objectForKeyNotNull:@"Title"];
    self.reviewTextView.text = [reviewData objectForKeyNotNull:@"ReviewText"];
    self.rateView.rating = [[reviewData objectForKeyNotNull:@"Rating"] floatValue];
}



- (void)viewDidAppear:(BOOL)animated
{
    // Setup the image preview AFTER the view has appeared and then
    // fade it in.  this isn't strictly necessary, but creates a 
    // smooth animation and is a nice effect.
    self.reviewImageView.alpha = 0;
    self.reviewImageView.image = self.reviewImage;
    [UIView animateWithDuration:1.0
                     animations:^ {
                         self.reviewImageView.alpha = 1;
                     }
     ];

    // Animate out the confirmation flash after a delay
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:1.0];   
    [UIView setAnimationDelay:5.0];
    [self.submitFlash setAlpha:0];
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [self setSubmitFlash:nil];
    [self setTitleLabel:nil];
    [self setReviewImageView:nil];
    [self setRateView:nil];
    [self setTitleLabel:nil];
    [self setReviewTextView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        return YES;    
    return NO;
}

@end
