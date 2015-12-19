//
//  BVProductsViewCell.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVProductsViewCell.h"
#import <FontAwesomeKit/FAKFontAwesome.h>

@interface BVProductsViewCell()

@end

@implementation BVProductsViewCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.adView = [[MyContentAdView alloc] initWithFrame:self.bounds];
        [self addSubview:self.adView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.adView.frame = self.bounds;
}

@end
