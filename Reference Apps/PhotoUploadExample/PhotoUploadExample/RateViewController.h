//
//  RateViewController.h
//  PhotoUploadExample
//
//  Created by Bazaarvoice Engineering on 4/25/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//
//  UIViewController for the form submission screen.  

#import <UIKit/UIKit.h>
#import "RateView.h"
#import <BVSDK/BVSDK.h>
#import "UIPlaceHolderTextView.h"
#import "RoundedCornerView.h"

@interface RateViewController : UIViewController<RateViewDelegate, BVDelegate, UITextViewDelegate>

// Star rating UIView
@property (weak, nonatomic) IBOutlet RateView *rateView;
// Review text entry field
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *reviewTextView;
// Review title entry field
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
// Field for nickname entry
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
// UIImageView to preview the image associated with this review
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@property (strong) BVPost *reviewSubmission;

// Loading overlay
@property (weak, nonatomic) IBOutlet UIView *overlay;
// Progress bar to indicate submission progress
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
// Label associated with the loading overlay
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
// Background for loading overlay
@property (weak, nonatomic) IBOutlet RoundedCornerView *loadingBevel;

// Keyboard dismiss/done button
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

// External property so that the preview image can be set by the prior
// UIViewController
@property (strong, nonatomic) UIImage *previewImage;
// Stores the imageUrl associated with this image upload.  In some sense
// it is a flag to indicate whether the photo upload has completed,
// since a URL is not available until we finish the upload and receive
// a response from the server.
@property (strong, nonatomic) NSString *imageUrl;

@property (strong) BVMediaPost *photoUploadRequest;

@end
