//
//  StarRatingView.h
//  RateAndReviewExample
//
//  Created by Bazaarvoice Engineering on 4/23/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//
//  This is a custom UIView for displaying an arbitrary floating
//  point star rating (for instance, to display average star rating
//  of a product).


#import <UIKit/UIKit.h>

@interface StarRatingView : UIView

// Rating this StarRatingView represents (out of 5)
@property (nonatomic) double rating;
// Boolean flag to indicat whether to display a star rating or
// "no ratings" text
@property (nonatomic, assign) BOOL noRatings;

@end
