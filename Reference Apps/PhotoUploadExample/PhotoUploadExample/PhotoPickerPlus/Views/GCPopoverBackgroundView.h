//
//  GCPopoverBackgroundView.h
//  PhotoPickerPlus-SampleApp
//
//  Created by Aleksandar Trpeski on 8/26/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCPopoverBackgroundView : UIPopoverBackgroundView {
    UIImageView *_borderImageView;
    UIImageView *_arrowView;
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
}

- (id)initWithFrame:(CGRect)frame;

@end
