//
//  ReviewCell.m
//  RateAndReviewExample
//
//  Created by Bazaarvoice Engineering on 4/23/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//

#import "ReviewCell.h"

@implementation ReviewCell

@synthesize image = _image, author = _author, review = _review, stars = _stars;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
