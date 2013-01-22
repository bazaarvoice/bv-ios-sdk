//
//  StarRatingView.m
//  RateAndReviewExample
//
//  Created by Bazaarvoice Engineering on 4/23/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//

#import "StarRatingView.h"

#define NUM_STARS 5.0

@interface StarRatingView ()

@property (nonatomic, weak) UIImageView *topImage;
@property (nonatomic, weak) UIImageView *bottomImage;
@property (nonatomic, weak) UILabel *noRatingsLabel;

@end


@implementation StarRatingView

@synthesize topImage = _topImage;
@synthesize bottomImage = _bottomImage;
@synthesize rating = _rating;
@synthesize noRatings = _noRatings;
@synthesize  noRatingsLabel = _noRatingsLabel;

- (void)awakeFromNib
{
    // The StarRatingView works by laying out two UIImageViews on top of eachother.  The 
    // bottomImage represents no stars while the topImage represents full stars.  The
    // topImage is cropped according to the rating so as to create the appearance
    // of a partial star rating.
    
    // Create and layout the top and bottom images
    UIImageView * topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UIImageView * bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    topImage.image = [UIImage imageNamed:@"fullstars_small.png"];
    bottomImage.image = [UIImage imageNamed:@"emptystars_small.png"];

    // Layout the images pinned to the top left corner
    topImage.contentMode = UIViewContentModeTopLeft;    
    bottomImage.contentMode = UIViewContentModeTopLeft; 
    
    // This is necessary so that the cropped part of the top image will not appear
    topImage.clipsToBounds = YES;
    bottomImage.clipsToBounds = YES;
    
    // Label for the no ratings case
    UILabel *noRatingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    noRatingsLabel.text = @"No Ratings";

    // Add all the views as subviews
    [self addSubview:bottomImage];
    [self addSubview:topImage];
    [self addSubview:noRatingsLabel];
    
    self.topImage = topImage;
    self.bottomImage = bottomImage;
    self.noRatingsLabel = noRatingsLabel;
    
    self.noRatings = NO;
    
    self.rating = 5;
}

- (void)setNoRatings:(BOOL)noRatings
{
    // If in the no ratings case, just display the label, otherwise
    // display the star rating images
    if(noRatings)
    {
        [self.noRatingsLabel setHidden:NO];
        [self.topImage setHidden:YES];
        [self.bottomImage setHidden:YES];
    }
    else 
    {
        
        [self.noRatingsLabel setHidden:YES];
        [self.topImage setHidden:NO];
        [self.bottomImage setHidden:NO];
    }
    _noRatings = noRatings;
}

- (void)setRating:(double)rating
{
    // When the rating is set, crop the top image to the appropriate
    // width to represene the star rating.
    
    // Caclculate the appropriate width to crop the top image to
    double starWidth = self.topImage.image.size.width / 5.0;
    
    // Set the top image frame to it's prior frame with an updated width
    CGRect oldFrame = self.frame;
    self.topImage.frame = CGRectMake(0, 0, 
                                     rating *starWidth, oldFrame.size.height);
    // Don't forget to set the underlying instance variable.
    _rating = rating;
}  

@end
