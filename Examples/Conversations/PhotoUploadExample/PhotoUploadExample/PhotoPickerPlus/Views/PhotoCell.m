//
//  PhotoCell.m
//  GCAPIv2TestApp
//
//  Created by Chute Corporation on 7/25/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

@synthesize imageView;
@synthesize overlayView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:[self.contentView frame]];
        self.overlayView = [[UIImageView alloc] initWithFrame:[self.contentView frame]];
        [self.overlayView setImage:[UIImage imageNamed:@"overlay.png"]];
        [self.contentView insertSubview:self.imageView atIndex:1];
        [self.contentView insertSubview:self.overlayView atIndex:2];
        [self.overlayView setHidden:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self.overlayView setHidden:!selected];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
