//
//  UILabelWithInset.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "UILabelWithInset.h"

@interface UILabelWithInset()

@property UIEdgeInsets insets;

@end

@implementation UILabelWithInset

-(id)initWithInset:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(void)drawTextInRect:(CGRect)rect {

    CGRect insetRect = UIEdgeInsetsInsetRect(rect, self.insets);
    [super drawTextInRect:insetRect];
}

@end
