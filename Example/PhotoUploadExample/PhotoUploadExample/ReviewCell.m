//
//  ReviewCell.m
//  Bazaarvoice SDK - Photo Upload Example Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "ReviewCell.h"

@implementation ReviewCell

@synthesize author = _author, review = _review, stars = _stars;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
