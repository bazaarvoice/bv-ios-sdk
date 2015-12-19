//
//  BVMyAdTypeCollectionViewCell.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVAdTypesCell.h"

@implementation BVAdTypesCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        
        self.descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.numberOfLines = 2;
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        self.descriptionLabel.textColor = [UIColor whiteColor];
        self.descriptionLabel.font = [UIFont systemFontOfSize:12];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageViewOverlay = [[UIView alloc] init];
        self.imageViewOverlay.layer.backgroundColor = [[UIColor blackColor] CGColor];
        self.imageViewOverlay.layer.opacity = 0.3f;
        [self.imageView addSubview:self.imageViewOverlay];
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.descriptionLabel];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    self.imageViewOverlay.frame = self.bounds;
    CGSize sizeThatFits = [self.titleLabel sizeThatFits:self.bounds.size];
    
    self.titleLabel.frame = CGRectMake(0,
                                       self.bounds.size.height/2,
                                       self.frame.size.width,
                                       sizeThatFits.height);
    
    self.descriptionLabel.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.titleLabel.frame),
                                             self.bounds.size.width,
                                             self.bounds.size.height - CGRectGetMaxY(self.titleLabel.frame));
}

@end
