//
//  PhotoPickerViewController.h
//  GCAPIv2TestApp
//
//  Created by Chute Corporation on 7/24/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoPickerViewController.h"

@class GCOAuth2Client;

@interface GCPhotoPickerViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


/**
 The PhotoPickerViewController and UINavigationController delegate object.
 
 @see PhotoPickerViewControllerDelegate
 @see UINavigationControllerDelegate
 */
@property (weak, nonatomic) id<PhotoPickerViewControllerDelegate, UINavigationControllerDelegate>delegate;

/**
 OAuth2Client used for authentication methods
 
 @warning This property requires `GCOAuth2Client` class. Add an `#import <Chute-SDK/GCOAuth2Client.h>` in your header/implementation file.
*/
@property (strong, nonatomic) GCOAuth2Client *oauth2Client;


/**
 BOOL value with which is determined if the user can select multiple assets (YES) or not (NO).
 */
@property (assign, nonatomic) BOOL isMultipleSelectionEnabled;

@end
