//
//  GCAccountMediaViewController.h
//  PhotoPickerPlus-SampleApp
//
//  Created by ARANEA on 8/20/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCAlbumViewController, GCAssetsCollectionViewController;

@interface GCAccountMediaViewController : UIViewController

/**
 The scrollView where the controllers are added.
*/
@property (strong, nonatomic) UIScrollView *scrollView;

/**
 The view controller that will be initialized if there are albums.
 
 @see GCAlbumViewController
 */
@property (strong, nonatomic) GCAlbumViewController             *albumViewController;

/**
 The view controller that will be initialized if there are assets.
 
 @see GCAssetsCollectionViewController
 */
@property (strong, nonatomic) GCAssetsCollectionViewController  *assetViewController;


/**
 BOOL value with which is determined if the user can select multiple assets (YES) or not (NO).
 */
@property (assign, nonatomic) BOOL                              isMultipleSelectionEnabled;

/**
 BOOL value with which is determined if the user is looking for an asset from the local-source (YES) or from online source (NO)
 */
@property (assign, nonatomic) BOOL                              isItDevice;

/**
 Number used to specify for which account it should ask for media data.
 */
@property (strong, nonatomic) NSNumber                          *accountID;

/**
  Number used to specify for which album it should ask for media data.
 */
@property (strong, nonatomic) NSNumber                          *albumID;

/**
  String used to specify for which service it should ask for media data.
 */
@property (strong, nonatomic) NSString                          *serviceName;


/**
 A block that gets called when user has selected asset(s).
 */
@property (readwrite, copy) void (^successBlock)(id selectedItems);

/**
 A block that gets called when user cancels photo picking.
 */
@property (readwrite, copy) void (^cancelBlock)(void);

@end
