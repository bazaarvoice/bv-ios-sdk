//
//  UIPlaceHolderTextView.h
//  Bazaarvoice SDK - Photo Upload Example Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//
//
//  A custom UITextView which can display placeholder text

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView {

    NSString *placeholder;
    UIColor *placeholderColor;
}

// Placeholder text
@property (nonatomic, strong) NSString *placeholder;
// Placeholder text color.  Grey by default.
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end

