//
//  ProductViewController.h
//  PhotoUploadExample
//
//  Created by Bazaarvoice Engineering on 4/18/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//
//  UIViewController for the initial product screen.  For this demo, it
//  contains purely static content, but presumably it might be a 
//  product detail page or something similar in practice.  Here, it is
//  merely used as a starting point to demonstrate use of the camera
//  and a review submission flow.

#import <UIKit/UIKit.h>
#import "PhotoPickerViewController.h"
#import <BVSDK/BVSDK.h>

@interface ProductViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,PhotoPickerViewControllerDelegate, UIActionSheetDelegate>

@end
