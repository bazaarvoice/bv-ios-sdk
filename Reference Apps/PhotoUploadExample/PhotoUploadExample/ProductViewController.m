//
//  ProductViewController.m
//  PhotoUploadExample
//
//  Created by Bazaarvoice Engineering on 4/18/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//

#import "ProductViewController.h"
#import "UIImage+Resize.h"
#import "RateViewController.h"
#import "BVColor.h"
#import <BVSDK/BVSDK.h>
#import <MobileCoreServices/UTCoreTypes.h>

#define MIN_SIZE 540

@interface ProductViewController ()

@end

@implementation ProductViewController

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    // Set up the global BVSettings object to store parameters
    // which are common to all requests.  In general, this should
    // only need to be done once.
    [BVSettings instance].passKey = @"2cpdrhohmgmwfz8vqyo48f52g";
    // These are test endpoints, merely to illustrate use of the api
    // calls to our stating server.
    [BVSettings instance].baseURL = @"reviews.apitestcustomer.Bazaarvoice.com";
    [BVSettings instance].staging = YES;
    
    self.navigationController.navigationBar.tintColor = [BVColor primaryBrandColor];
    self.navigationController.navigationBar.alpha = .9;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

// Handler for when the "rate" button is clicked
- (IBAction)rateClicked:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Select Photo From:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"My Photos", nil];
   [popupQuery showInView:self.view];
}

// Handler for when an item is selected from the "rate" action item list.  We present two possible ways to obtain photos.  The first
// is from the camera.  The second is utilizing the Chute photo picker plus library.  See here:
// https://github.com/chute/photo-picker-plus/
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        // First, check to make sure the camera is available.
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // Kick off the image picker with this object as a delegate
            // to receive callbacks when a photo has been taken
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            // Indicate that we only want images
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            picker.mediaTypes = [NSArray arrayWithObjects:
                                 (NSString *) kUTTypeImage, nil];
            [self presentModalViewController:picker animated:YES];
        }
	} else if (buttonIndex == 1) {
        PhotoPickerPlus *picker = [[PhotoPickerPlus alloc] init];
        [picker setDelegate:self];
        [picker setModalPresentationStyle:UIModalPresentationFormSheet];
        [picker setModalInPopover:YES];
        [picker setMultipleImageSelectionEnabled:NO];
        [picker setSourceType:PhotoPickerPlusSourceTypeLibrary];
        [self presentViewController:picker animated:YES completion:^(void){
        }];
    } 
}

// Single endpoint for all photo selections -- camera or from picker
- (void)handlePickedPhotoWithInfo:(NSDictionary *)info {
    // Access the image that the user took and perform a segue
    // immediately.  Note that we are not blocking the user while the
    // photo is uploading, but will upload the photo in the background
    // while the user fills out a form, rating etc.
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // MIN_SIZE is a client config-specific parameter.  In our example client-config, images must be at least 533x533, so we scale up images which are
    // smaller than our minimum size.  This may or may not be a best practice depending on your specific implementation.
    if(image.size.width < MIN_SIZE || image.size.height < MIN_SIZE){
        float scale = MAX(MIN_SIZE / image.size.height, MIN_SIZE / image.size.width);
        // Image resizing is optional, but may be useful in some cases.
        image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                            bounds:CGSizeMake(image.size.height * scale, image.size.width * scale)
                              interpolationQuality:kCGInterpolationHigh];
    }
    [self performSegueWithIdentifier:@"rate" sender:image];
}

// Camera/native SDK callbacks
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    [self handlePickedPhotoWithInfo:info];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // If the user cancels, dismiss and do nothing
    [self dismissModalViewControllerAnimated:YES];
}

// PhotoPickerPlus callbacks
-(void) PhotoPickerPlusController:(PhotoPickerPlus *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissModalViewControllerAnimated:YES];
    [self handlePickedPhotoWithInfo:info];
}

-(void) PhotoPickerPlusController:(PhotoPickerPlus *)picker didFinishPickingArrayOfMediaWithInfo:(NSArray *)info {
    // Not utilized -- this is for cases where multiple photo selection is allowed
}

-(void) PhotoPickerPlusControllerDidCancel:(PhotoPickerPlus *)picker{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Note that this is where we actually kick off the network
    // request to upload the photo.  Rather than setting this
    // object as the upload delegate, we set the following
    // view controller as the delegate
    if ([segue.identifier isEqualToString:@"rate"]) {
        RateViewController *rateController = segue.destinationViewController;
        [self submitPhoto:sender delegate:rateController];
        rateController.previewImage = sender;
    }
}

// This function actually begins the photo upload via the BV SDK
- (BVMediaPost *)submitPhoto:(UIImage *)image delegate:(RateViewController *)delegate
{
    
    // Create a photo submission request
    BVMediaPost *mySubmission = [[BVMediaPost alloc] initWithType:BVMediaPostTypePhoto];
    // With photo submission, we must explicitly set the content type. 
    // In this case, we are uploading a photo to a story
    mySubmission.contentType = BVMediaPostContentTypeReview;
    
    // Set the photo and delegate parameters
    mySubmission.photo = image;
    // User that is uploading this photo
    mySubmission.userId = @"testuserid111";
    
    delegate.photoUploadRequest = mySubmission;
    
    // Kick off the request
    [mySubmission sendRequestWithDelegate:delegate];
    

    return mySubmission;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        return YES;    
    return NO;
}

@end
