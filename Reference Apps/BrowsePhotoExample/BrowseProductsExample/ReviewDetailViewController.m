//
//  ReviewDetailViewController.m
//  BrowseProductsExample
//
//  Created by Bazaarvoice Engineering on 4/25/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//

#import "ReviewDetailViewController.h"
#import "NSDictionary+Utils.h"
#import "UIImageView+WebCache.h"

@interface ReviewDetailViewController ()

@end

@implementation ReviewDetailViewController

@synthesize reviewData = _reviewData;
@synthesize review = _review;
@synthesize reviewTitle = _reviewTitle;
@synthesize starRating = _starRating;
@synthesize reviewImage = _reviewImage;

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
	
    // Upon load, fill in all of the review information to display.
    self.reviewTitle.text = [self.reviewData objectForKeyNotNull:@"Title"];
    self.review.text = [self.reviewData objectForKeyNotNull:@"ReviewText"];
    self.starRating.rating = [[self.reviewData objectForKeyNotNull:@"Rating"] floatValue];
    
    // If a photo is available, display it, otherwise display a placeholder
    NSArray *photos = [self.reviewData objectForKeyNotNull:@"Photos"];
    if(photos && photos.count > 0)
    {
        NSString *url = [[[[photos objectAtIndex:0] objectForKeyNotNull:@"Sizes"] objectForKeyNotNull:@"normal"] objectForKeyNotNull:@"Url"];
        [self.reviewImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading_icon.gif"]];
    } 
    else 
    {
        self.reviewImage.image = [UIImage imageNamed:@"camera_icon.gif"];
    }
}

- (void)viewDidUnload
{
    [self setReview:nil];
    [self setReviewTitle:nil];
    [self setStarRating:nil];
    [self setReviewImage:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
