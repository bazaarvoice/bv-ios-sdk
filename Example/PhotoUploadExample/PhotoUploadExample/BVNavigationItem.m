//
//  BVNavigationItem.m
//  PhotoUploadExample
//
//  Created by Bazaarvoice Engineering on 4/27/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//

#import "BVNavigationItem.h"
#import "BVColor.h"

@implementation BVNavigationItem

// When the title is set, we wish to set it to a label with
// a predefined color
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UIImage *image = [UIImage imageNamed:@"graphic-star.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 30, 30);
    self.titleView = imageView;

    
    /* Custom Label Color - Uncomment if you prefer to have a title label
    UILabel *titleView = (UILabel *)self.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        // Change to desired color
        titleView.textColor = [BVColor secondaryBrandColor];        
        self.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
     */
}


@end
