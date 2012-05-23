//
//  ProductViewController.m
//  PhotoUploadExample
//
//  Created by Bazaarvoice Engineering on 4/18/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//

#import "ProductViewController.h"
#import "UIImage+Resize.h"
#import "RateViewController.h"
#import "BVColor.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ProductViewController ()
// Private method to kick off photo submission
- (BVSubmission *)submitPhoto:(UIImage *)image delegate:(id)delegate;
@end

@implementation ProductViewController

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    // Set up the global BVSettings object to store parameters
    // which are common to all requests.  In general, this should
    // only need to be done once.
    [BVSettings instance].passKey = @"u16cwr987fkx0hprzhrbqbmqo";
    // These are test endpoints, merely to illustrate use of the api
    // calls to our stating server.
    [BVSettings instance].customerName = @"directbuy.ugc"; 
    [BVSettings instance].dataString = @"bvstaging/data";
    [BVSettings instance].apiVersion = @"5.1";
    
    self.navigationController.navigationBar.tintColor = [BVColor primaryBrandColor];
    self.navigationController.navigationBar.alpha = .9;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

// Handler for when the "rate" button is clicked
- (IBAction)rateClicked:(id)sender {
    // First, check to make sure the camera is available.
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // Kick off the image picker with this object as a delegate
        // to receive callbacks when a photo has been taken
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // Indicate that we only want images
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage, nil];
        [self presentModalViewController:picker animated:YES];
    }
}

// Image picker delegate callbacks

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissModalViewControllerAnimated:YES];
    // Access the image that the user picked and perform a segue
    // immediately.  Note that we are not blocking the user while the 
    // photo is uploading, but will upload the photo in the background
    // while the user fills out a form, rating etc.
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSegueWithIdentifier:@"rate" sender:image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // If the user cancels, dismiss and do nothing
    [self dismissModalViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Note that this is where we actually kick off the network
    // request to upload the photo.  Rather than setting this
    // object as the upload delegate, we set the following
    // view controller as the delegate
    if ([segue.identifier isEqualToString:@"rate"]) {
        RateViewController *rateController = segue.destinationViewController;
        rateController.photoSubmission = [self submitPhoto:sender delegate:rateController];
        rateController.previewImage = sender;
    }
}

// This function actually begins the photo upload via the BV SDK
- (BVSubmission *)submitPhoto:(UIImage *)image delegate:(id)delegate
{
    // Create a photo submission request
    BVSubmissionPhoto *mySubmission = [[BVSubmissionPhoto alloc] init];
    // With photo submission, we must explicitly set the content type. 
    // In this case, we are uploading a photo to a story
    mySubmission.parameters.contentType = @"story";
    //UIImage *im = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(1000, 1000) interpolationQuality:kCGInterpolationHigh];
    // Set the photo and delegate parameters
    mySubmission.parameters.photo = image;
    mySubmission.delegate = delegate;
    // User that is uploading this photo
    mySubmission.parameters.userId = @"testuserid111";
    // Kick off the request
    [mySubmission startAsynchRequest];     
    return mySubmission;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        return YES;    
    return NO;
}

@end
