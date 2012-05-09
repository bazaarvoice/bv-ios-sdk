//
//  RoundedCornerView.m
//  PhotoUploadExample
//
//  Created by Alex Medearis on 5/8/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//

#import "RoundedCornerView.h"
#import "BVColor.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedCornerView


- (void)baseInit {
    [self.layer setCornerRadius:30.0f];
    [self.layer setBorderColor:[BVColor bvGreen].CGColor];
    [self.layer setBorderWidth:2.0f];
    self.backgroundColor = [BVColor bvBlue];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
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
