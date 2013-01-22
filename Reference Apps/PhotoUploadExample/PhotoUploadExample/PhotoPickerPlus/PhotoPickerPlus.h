//
//  PhotoPickerPlus.h
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 1/21/12.
//  Copyright (c) 2012 Chute Corporation. All rights reserved.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "GetChute.h"

#define ADD_SERVICES_ARRAY_NAMES [NSArray arrayWithObjects:@"Facebook", @"Instagram", @"Flickr", @"Picasa", nil]
#define ADD_SERVICES_ARRAY_LINKS [NSArray arrayWithObjects:@"facebook", @"instagram", @"flickr", @"google", nil]
#define USE_DEVICE_TITLE @"Device"

#define CANCEL_BUTTON_TEXT  @"Cancel"
#define DONE_BUTTON_TEXT  @"Done"
#define BACK_BUTTON_TEXT  @"Back"

#define CAMERA_OPTION_TEXT @"Take Photo"
#define DEVICE_SINGLE_OPTION_TEXT @"Choose Photo"
#define DEVICE_PLURAL_OPTION_TEXT @"Choose Photos"
#define LATEST_OPTION_TEXT @"Last Photo Taken"
#define CANCEL_OPTION_TEXT @"Cancel"

#define PHOTO_COUNT_FORMAT @"Loaded %i photos in this album"

#define messageTime 2

#define THUMB_COUNT_PER_ROW ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 6 : 4)

#define MIN_THUMB_SPACING ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 4 : 1)

#define MAX_THUMB_SIZE 100
//thumb size greater than 100 will cause blurriness adjust greater at own risk.

#define THUMB_SIZE (MIN(floor((photosTable.frame.size.width-(MIN_THUMB_SPACING*(THUMB_COUNT_PER_ROW+1)))/THUMB_COUNT_PER_ROW),MAX_THUMB_SIZE))

#define THUMB_SPACING (MAX(floor((photosTable.frame.size.width-(THUMB_COUNT_PER_ROW*THUMB_SIZE))/(THUMB_COUNT_PER_ROW+1)),MIN_THUMB_SPACING))

enum {
    PhotoPickerPlusSourceTypeAll,
    PhotoPickerPlusSourceTypeLibrary,
    PhotoPickerPlusSourceTypeCamera,
    PhotoPickerPlusSourceTypeNewestPhoto
};
typedef NSUInteger PhotoPickerPlusSourceType;

@protocol PhotoPickerPlusDelegate;

@interface PhotoPickerPlus : GCUIBaseViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

//The delegate used for returning image info
@property (nonatomic, assign) NSObject <PhotoPickerPlusDelegate> *delegate;

@property (nonatomic) BOOL appeared;

//set to the source of the image selected
@property (nonatomic) PhotoPickerPlusSourceType sourceType;
@property (nonatomic) UIModalPresentationStyle presentationStyle;

@property (nonatomic) BOOL multipleImageSelectionEnabled;  //Allows users to select multiple images.  Requires location services for device photos.
@property (nonatomic) BOOL useStandardDevicePicker;  //Use standard UIImagePicker for device photos only allows single image selection from device but doesn't require location services.
@property (nonatomic) BOOL offerLatestPhoto;    //Offer option to use latest photo.  Note that this will require location serivices to work.

@end

@interface AccountViewController : GCUIBaseViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSObject <PhotoPickerPlusDelegate> *delegate;
@property (nonatomic, assign) PhotoPickerPlus *P3;

@property (nonatomic, retain) NSArray *photoAlbums;
@property (nonatomic, retain) NSArray *accounts;

@property (nonatomic, retain) UITableView *accountsTable;

@property (nonatomic) int accountIndex;

@property (nonatomic) BOOL multipleImageSelectionEnabled;
@property (nonatomic) BOOL useStandardDevicePicker;

-(UIView*)tableView:(UITableView *)tableView viewForIndexPath:(NSIndexPath*)indexPath;

@end

@interface AccountLoginViewController : GCUIBaseViewController <UIWebViewDelegate>

@property (nonatomic, retain) UIWebView *AddServiceWebView;
@property (nonatomic, retain) NSString *service;

@end

@interface AlbumViewController : GCUIBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSObject <PhotoPickerPlusDelegate> *delegate;
@property (nonatomic, assign) PhotoPickerPlus *P3;

@property (nonatomic, retain) NSArray *albums;

@property (nonatomic, retain) UITableView *albumsTable;

@property (nonatomic) BOOL multipleImageSelectionEnabled;
@property (nonatomic) BOOL useStandardDevicePicker;

@property (nonatomic, assign) NSDictionary *account;

-(UIView*)tableView:(UITableView *)tableView viewForIndexPath:(NSIndexPath*)indexPath;

@end

@interface PhotoViewController : GCUIBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSObject <PhotoPickerPlusDelegate> *delegate;
@property (nonatomic, assign) PhotoPickerPlus *P3;

@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, retain) NSMutableOrderedSet *selectedAssets;

@property (nonatomic, retain) UITableView *photosTable;

@property (nonatomic, retain) UIView *photoCountView;
@property (nonatomic, retain) UILabel *photoCountLabel;

@property (nonatomic) BOOL multipleImageSelectionEnabled;
@property (nonatomic) BOOL useStandardDevicePicker;
@property (nonatomic, assign) NSDictionary *account;
@property (nonatomic, assign) NSDictionary *album;
@property (nonatomic, assign) ALAssetsGroup *group;

-(UIView*)tableView:(UITableView *)tableView viewForIndexPath:(NSIndexPath*)indexPath;

@end

@protocol PhotoPickerPlusDelegate <NSObject>

-(void)PhotoPickerPlusController:(PhotoPickerPlus *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
-(void)PhotoPickerPlusControllerDidCancel:(PhotoPickerPlus *)picker;
-(void)PhotoPickerPlusController:(PhotoPickerPlus *)picker didFinishPickingArrayOfMediaWithInfo: (NSArray*)info;

@end

