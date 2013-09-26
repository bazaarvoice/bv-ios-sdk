//
//  GCPopupView2.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 4/8/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCPopupView.h"
#import "KXDataEncoder.h"
#import <QuartzCore/QuartzCore.h>

static float const kScaleFactor = 0.85;//0.91;
static float const kSpacingSize = 15.0;

static int const kBorderWidth = 2;
static int const kCornerRadius = 8;
static float const kShadowOpacity = 0.75;
static int const kShadowRadius = 16;

static float const kShowAnimationDuration = 0.25;
static float const kBounceAnimationDuration = 0.075;
static float const kHideAnimationDuration = 0.2;

static CGPoint startPoint;
static CGPoint endPoint;

@interface GCPopupView () {
    UIView *_parentView;
    CGAffineTransform rotationTransform;
        
}

@end

@implementation GCPopupView

- (id)initWithFrame:(CGRect)frame inParentView:(UIView *)parentView
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _parentView = parentView;
        
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[self closeImage] forState:UIControlStateNormal];
        [closeButton setFrame:[self contentViewFrame]];
        [closeButton addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
        
        contentView = [[UIView alloc] initWithFrame:[self contentViewFrame]];
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.autoresizesSubviews = YES;
        
        contentView.layer.cornerRadius = kCornerRadius;
        contentView.layer.borderWidth = kBorderWidth;
        contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        contentView.clipsToBounds = YES;
        
        [self setShadow];
        [self  registerForNotifications];
        
        [self addSubview:contentView];
        [self addSubview:closeButton];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
        
	if (_parentView) {
		self.frame = _parentView.bounds;
	}
	CGRect bounds = self.bounds;
    
    [self setFrame:[GCPopupView popupFrameForView:_parentView withStartPoint:CGPointZero]];
    [closeButton setFrame:[self closeButtonFrame]];
    [contentView setFrame:[self contentViewFrame]];
    
    [self setShadow];
}

- (CGRect)closeButtonFrame {
    return CGRectMake(0.0, 0.0, kSpacingSize * 2, kSpacingSize * 2);
}

- (CGRect)contentViewFrame {
    return CGRectMake(kSpacingSize, kSpacingSize, self.bounds.size.width - kSpacingSize * 2.0, self.bounds.size.height - kSpacingSize * 2.0);
}

+ (CGRect)popupFrameForView:(UIView *)_view withStartPoint:(CGPoint)_startPoint {
    
    startPoint = _startPoint;
    endPoint = _view.layer.position;
    
    float factorWidth = kScaleFactor * _view.bounds.size.width;
    float factorHeight = kScaleFactor * _view.bounds.size.height;
    float factorX = (_view.bounds.size.width - factorWidth) / 2.0;
    float factorY = (_view.bounds.size.height - factorHeight) / 2.0;
    
    return CGRectMake(factorX, factorY, factorWidth, factorHeight);
    
}

+ (void)show
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [self showInView:window fromStartPoint:window.layer.position];
}

+ (void)showInView:(UIView *)view {
    [self showInView:view fromStartPoint:view.layer.position];
}

+ (void)showInView:(UIView *)_view fromStartPoint:(CGPoint)_startPoint {
    
    CGRect popupFrame = [self popupFrameForView:_view withStartPoint:_startPoint];
    
    GCPopupView *popup = [[self alloc] initWithFrame:popupFrame inParentView:_view];
    
    [_view addSubview:popup];
    
    [popup showPopupWithCompletition:^{
        
    }];
    
}

#pragma mark - Util Method

- (void)setShadow {
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = kShadowOpacity;
    self.layer.shadowRadius = kShadowRadius;
    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
}

- (UIImage *)closeImage {
    NSString *strClose = @"iVBORw0KGgoAAAANSUhEUgAAABoAAAAaCAYAAACpSkzOAAAFWElEQVRIDZVWWUidVxCe639d4paoiaK44XK9qQQ0gmApJBIouJCWgNJIhbRPSh6EIBd8U4hQQgjkoS+BVvHBgBBDH4MSjQr64PbghgsuwRj3fd/6fdN7zFUJbQ8M59xzZuab+WbO+a/t9PRUvjaqq6vt3t7eTsgdu91+27Isp5eXVxTWgvkTZATSC/sPR0dHI3t7e0dbW1uyu7srh4eH8vTp0zPX9rPVhUVVVdVNOHx0fHz8AMEkwtDGoGw2G0EEZ/EI4FsfH59fME9AGrFXi3kYIpubm+c8XgJyuVz+iPwhpBxROun85OREOBvxABMA2a5cuZLk7+/vwvo+wJ4HBAS8hu6OJ9I5oJKSkjBE4/L19X2MTAI8QTyNPNfMjnQBTAIDA50AeQkwB4CfQW/Z6Cod/FFUVOSPqRKKT2BkMWoC/dcBBpidBAcHE/AYAb8A3ZVlZWWa2VlGa2trPwGg1M/Pz2IhV1dXZXJyUnZ2doScO51OdcIAzKDe0tKSfPz4UQ4ODrR2GRkZEhMTYwUFBZUCfAS6f1JfM8rOznbCwV/Xr193QEEAJpmZmZKVlSX7+/tSW1srra2t4nA4GK3B0YwTExMlPz9fs6mvr5f3799Lenq6XL16VcDOKFj5oaKiYsSCA2t7e7sczu8ThJyT79jYWBVwLQkJCRp1d3e3hIaGavRES05Olry8PLl27ZqgptLf3y+fP39WezYQfIVBbae5ubnFAvI3UKrCHMpMqIBiqjPSFBERIQwAdMjU1JQMDg5qizO73NxcCQ8PF3SnNDU1CQMhzbTjHmuMdQR8NltIrxCHPzNVAhCIdHFG3ZRGOmMmlNHRUaWvoKBAM6VeW1ubvHv3Ti+p8cEMCYSsQqEzZKFLStEt6YyakVCB0YBOVWRTIBi5ceOGREZGaoaswa1bt1S/q6tL3r59q01DewIbH1xzAHCeQC5QFmOKzEOjzI7jmmBs3bCwMK1bVFSUBtPe3i4NDQ2yvr4ubG9mYOzNTHCMXTs2IhkBW5WHF8f8/Ly+XWyK6OhoCQkJURXSSrrYAPHx8Wp/0ZaNRSGGnSC8A6wL+fUcjIY0sgtJG5vFDAKnpaXJwMCArKysaOe5ozcqSq2h04JBIRBjjBMCewqeI8nJyZF79+4p0MTEhFLFbmR7M+Kenp6zC0tWjL1hCPOwhWi/w0E6HRLdKHEm72xhXkgGMjY2Jm/evNE7RSDWLCkpSUF6e3vV1mRAe9bMXbdmCw6i8SOXCqagzJ3U3L17VwoLC7XrFhYWpKamRvr6+rQjSXdcXJw+SykpKXoVhoeHtc4GzAAB9A8L3bSDje/RDKGmRuwwghQXF+tl5bfl1atX0tLSolGzG/lis658gtixqampMjc3J0NDQ3ppmZGbxnGsf/PCjxFIo7k7NCYQXwLSxf26ujq9+exMnm9sbMjs7Kx0dnZq55mGYdsTgHrc44zMG2EzYofRMSKqAVs/4pI6mC4VxsfHZXp6WhYXF6Wjo0PpYuHpgIOvNp8bPjt8F1ljZkP6SSvpg4xCtWZmZub47HuEmvyKzZc4DORd4bNDZdJGmhjpxUEgvhh0Th3qmkCguwX7MjyyXz4TdACa9MOH5RMosHbqgGD/Z5ARDEb1AraVy8vL+uE7y4incM5n3QV5DAlgc5Augv0boOkwzNvQ/R3yDBle/pTDsQ7QwcweQsohTiBcAlNQ3hG10EdT7wt+8ov6HOevvWw2NOeX/yfnMnLb6QTeb2LxCPIAkgiB/T80mtlNE/EmII3Yr4UMm3N2qBlfBaICaOPj54Tcgdx2r6Mwc3yCMINeOP7gXh8ZEPz2bAz5G7HMLfQuQmGwAAAAAElFTkSuQmCC";
    
    return [UIImage imageWithData:[KXDataEncoder dataWithBase64EncodedString:strClose]];
}

#pragma mark - Actions

- (void)closePopup {
    [self closePopupWithCompletition:nil];
}

- (void)showPopupWithCompletition:(void (^)(void))completition {
    
    [self setTransform:CGAffineTransformMakeScale(0.001, 0.001)];
    [self setAlpha:0.001];
    [self.layer setPosition:startPoint];
    
    [UIView animateWithDuration:kShowAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [[self layer] setPosition:endPoint];
        [self setAlpha:1.0];
        [self setTransform:CGAffineTransformIdentity];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kBounceAnimationDuration delay:0.0 options:(UIViewAnimationOptionAutoreverse|UIViewAnimationCurveEaseOut) animations:^{
            [self setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
        } completion:^(BOOL finished) {
            completition();
            [self setTransformForCurrentOrientation:YES];
        }];
    }];
}

- (void)closePopupWithCompletition:(void (^)(void))completition {
    
    [UIView animateWithDuration:kHideAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.layer setPosition:startPoint];
        [self setAlpha:0.001];
        [self setTransform:CGAffineTransformMakeScale(0.001, 0.001)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self unregisterFromNotifications];
        if (completition)
            completition();
    }];
}
#pragma mark - Notifications

- (void)registerForNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(deviceOrientationDidChange:)
			   name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterFromNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
	UIView *superview = self.superview;
	if (!superview) {
		return;
	} else if ([superview isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:YES];
	} else {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
	// Stay in sync with the superview
	if (self.superview) {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat radians = 0;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -(CGFloat)M_PI_2; }
		else { radians = (CGFloat)M_PI_2; }
		
        // Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);

	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = (CGFloat)M_PI; }
		else { radians = 0; }
	}
	rotationTransform = CGAffineTransformMakeRotation(radians);
    
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}

@end
