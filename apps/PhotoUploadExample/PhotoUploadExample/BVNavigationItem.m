//
//  BVNavigationItem.m
//  PhotoUploadExample
//
//  Created by Bazaarvoice Engineering on 4/27/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//

#import "BVNavigationItem.h"
#import "BVColor.h"

@implementation BVNavigationItem

// When the title is set, we wish to set it to a label with
// a predefined color
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        // Change to desired color
        titleView.textColor = [BVColor bvGreen];        
        self.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}


@end
