//
//  DeviceAlbumViewController.h
//  PhotoPickerPlus-SampleApp
//
//  Created by ARANEA on 8/5/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCAlbumViewController : UITableViewController

/**
 BOOL value with which is determined if the user can select multiple assets (YES) or not (NO).
 */
@property (nonatomic) BOOL isMultipleSelectionEnabled;

/**
 BOOL value with which is determined if the user is looking for an asset from the local-source (YES) or from online source (NO)
 */
@property (nonatomic) BOOL isItDevice;


/**
 Number used to specify for which account it should ask for media data.
 */
@property (strong, nonatomic) NSNumber *accountID;

/**
 String used to specify for which service it should ask for media data.
 */
@property (strong, nonatomic) NSString *serviceName;

/**
 Array used to specify which albums to be shown in table view. 
*/
@property (strong, nonatomic) NSArray *albums;


/**
 A block that gets called when user has selected asset(s).
 */
@property (readwrite, copy) void (^successBlock)(id selectedItems);

/**
 A block that gets called when user cancels photo picking.
 */
@property (readwrite, copy) void (^cancelBlock)(void);


/**
 Sets cancel button in the right corner of NavigationBar.
 
 @return UIBarButtonItem
 */
- (UIBarButtonItem *)setCancelButton;


@end
