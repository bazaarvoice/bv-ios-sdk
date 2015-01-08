//
//  UIPlaceHolderTextView.m
//  PhotoUploadExample
//
//  Created by Alex Medearis on 4/27/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//

#import "UIPlaceHolderTextView.h"


@interface UIPlaceHolderTextView ()
@property (nonatomic, weak) UILabel *placeHolderLabel;
@end

@implementation UIPlaceHolderTextView

@synthesize placeHolderLabel = _placeHolderLabel;
@synthesize placeholder = _placeHolder;
@synthesize placeholderColor = _placeHolderColor;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if(self.placeholder.length > 0 )
    {
        if ( !self.placeHolderLabel)
        {
            UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            self.placeHolderLabel = placeHolderLabel;
            [self addSubview:placeHolderLabel];
        }
        
        self.placeHolderLabel.text = self.placeholder;
        [self.placeHolderLabel sizeToFit];
        [self sendSubviewToBack:self.placeHolderLabel];
    }
    if( [[self text] length] == 0 && self.placeholder.length > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
}

@end