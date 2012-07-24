//
//  RateViewController.m
//  PhotoUploadExample
//
//  Created by Bazaarvoice Engineering on 4/25/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//

#import "RateViewController.h"
#import "ConfirmViewController.h"
#import "BVColor.h"

@interface RateViewController ()
// Flag indicating whether the form has been submitted
// This comes into play when we receive notification that
// photo upload has completed
@property (nonatomic, assign) BOOL formHasBeenSubmitted;

// Flag indicating whether the form is moved up 
@property (nonatomic, assign) BOOL isMovedUp;

// Checks to ensure there is submission data
- (BOOL)validateFields;

// Private method to kick of rating submission
- (void)submitRating;
@end

@implementation RateViewController

@synthesize rateView = _rateView;
@synthesize overlay = _overlay;
@synthesize imageUrl = _imageUrl;
@synthesize progressBar = _progressBar;
@synthesize reviewTextView = _textView;
@synthesize doneButton = _doneButton;
@synthesize loadingLabel = _loadingLabel;
@synthesize loadingBevel = _loadingBevel;
@synthesize titleTextField = _titleView;
@synthesize nicknameTextField = _nicknameTextField;
@synthesize previewImageView = _photoPreview;
@synthesize previewImage = _previewImage;
@synthesize formHasBeenSubmitted = _formHasBeenSubmitted;
@synthesize reviewSubmission = _reviewSubmission;
@synthesize photoSubmission = _photoSubmission;
@synthesize isMovedUp = _isMovedUp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.formHasBeenSubmitted = NO;
        self.isMovedUp = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // RateView setup
    self.rateView.notSelectedImage = [UIImage imageNamed:@"empty_star.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"half_star.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"full_star.png"];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    
    self.loadingBevel.backgroundColor = [UIColor whiteColor];
    
    // We do not want to display the right bar button item initially
    // It will be used to dismiss the keyboard.
    self.navigationItem.rightBarButtonItem = nil;
    
    // UIPlaceHolderTextView setup
    self.reviewTextView.placeholder = @"Review";
}

-(void)viewDidAppear:(BOOL)animated
{
    // Setup the image preview AFTER the view has appeared and then
    // fade it in.  this isn't strictly necessary, but creates a 
    // smooth animation and is a nice effect.
    self.previewImageView.alpha = 0;
    self.previewImageView.image = self.previewImage;
    [UIView animateWithDuration:1.0
                     animations:^ {
                         self.previewImageView.alpha = 1;
                     }
     ];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // This is necessary for the case that the user cancels.  We must set the
    // delegate to nil to avoid callbacks to a dealocated instance.
    self.reviewSubmission.delegate = nil;
    self.photoSubmission.delegate = nil;
}

- (void)viewDidUnload
{
    [self setRateView:nil];
    [self setOverlay:nil];
    [self setReviewTextView:nil];
    [self setDoneButton:nil];
    [self setTitleTextField:nil];
    [self setPreviewImageView:nil];
    [self setPreviewImageView:nil];
    [self setProgressBar:nil];
    [self setLoadingLabel:nil];
    [self setLoadingBevel:nil];

    [self setNicknameTextField:nil];
    [super viewDidUnload];
}

// INPUT ANIMATION

// This is the offset to animate the form when the keyboard appears
#define kOFFSET_FOR_KEYBOARD 180.0

// When the review text view begins editing, move the field up and
// display the done button
- (IBAction)textViewDidBeginEditing:(UITextView *)textView{
    [self setViewMovedUp:YES];
    self.navigationItem.rightBarButtonItem = self.doneButton;

}

// When the title view begins editing, display the done button to 
// dismiss
- (IBAction)titleViewDidBeginEditing:(id)sender {
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

// When done is clicked, animated down if necessary, resign
// first respondes, and hide the done button
- (IBAction)doneClicked:(id)sender {
    if(self.reviewTextView.isFirstResponder || self.nicknameTextField.isFirstResponder)
    {
        [self setViewMovedUp:NO];
    }
    [self.reviewTextView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.nicknameTextField resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

// Method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)up
{
    if(up == self.isMovedUp)
    {
        return;
    }
    self.isMovedUp = up;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (up)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

// Handler for submit being pressed
- (IBAction)submitClicked:(id)sender 
{
    [self submitRating];
}

- (void)submitRating
{
    // Check to make sure our fields have content.  If there is a problem, alert
    // the user and don't submit.
    if(![self validateFields]) {
        return;
    }
    
    // If we have an imageURL, it means that the photo has successfully uploaded
    // and we can immediatly submit the review.
    if(self.imageUrl)
    {
        NSLog(@"Image URL: %@", self.imageUrl);
        
        // Create a review submission with the BV SDK
        BVSubmissionReview *mySubmission = [[BVSubmissionReview alloc] init];
        
        // Fill in the request paramters
        mySubmission.parameters.productId = @"10sdfsdf000132";
        // To do an actual submission, uncomment this line.  The default is "preview."
        //mySubmission.parameters.action = @"submit";
        mySubmission.parameters.userId = @"123abc";
        int rating = (int)self.rateView.rating;
        mySubmission.parameters.rating = [NSString stringWithFormat:@"%d", rating];
        mySubmission.parameters.title = self.titleTextField.text;
        mySubmission.parameters.reviewText = self.reviewTextView.text;
        mySubmission.parameters.userNickName = self.nicknameTextField.text;
        
        // This type name is the index of the phot in the upload... it maps to photo_1 = ...
        [mySubmission.parameters.photoURL addKey:@"1" andValue:self.imageUrl];
        
        // Set this object as the request delegate and kick off the request
        mySubmission.delegate = self;
        self.reviewSubmission = mySubmission;
        [mySubmission startAsynchRequest];
        
        // Update the loading indicator
        self.loadingLabel.text = @"Submitting Review...";
    }
    self.formHasBeenSubmitted = YES;
    [self.overlay setHidden:NO];
}

-(void) didReceiveResponse:(BVResponse *)response forRequest:(BVBase *)request
{
    // Since this object is a DVDelegate for both the photo submission and 
    // review submission, we must determine which case we are in
    
    if([request isKindOfClass:[BVSubmissionPhoto class]])
    {
        // If the photo request has responded, we want to identify the 
        // new photo url so that it can be included with the form submission
         NSString *url = [[[[response.rawResponse objectForKey:@"Photo"] objectForKey:@"Sizes"] objectForKey:@"normal"] objectForKey:@"Url"];
        
        if(response.hasErrors)
        {           
            // If there are errors, reset the submission and alert the user.
            NSDictionary *anError = [(NSArray*)response.errors objectAtIndex:0];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Upload Error!"
                                                              message:[anError objectForKey:@"Message"]                                                           delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.imageUrl = url;
        
        // If the user has already clicked submit, kick off the review submission
        // immediately
        if (self.formHasBeenSubmitted) 
        {
            [self submitRating];
        }
    }
    else if([request isKindOfClass:[BVSubmissionReview class]])
    {
        
        if(response.hasErrors) {
            
            NSLog(@"%@", response.errors);
            NSLog(@"%@", response.rawResponse);
            [self.overlay setHidden:YES];
            
            // If there are errors, reset the submission and alert the user.
            NSString * errorMessage;
            
            if(response.errors.count > 0)
            {
                NSDictionary * anError = [(NSArray*)response.errors objectAtIndex:0];
                errorMessage = [anError objectForKey:@"Message"];
            } 
            else if([response.rawResponse objectForKey:@"FormErrors"] > 0) 
            {
                NSDictionary * formErrors = [response.rawResponse objectForKey:@"FormErrors"];
                NSDictionary * fieldErrors = [[formErrors allValues] objectAtIndex:0];
                if(fieldErrors.count > 0)
                {
                    NSDictionary * anError = [[fieldErrors allValues] objectAtIndex:0];
                    errorMessage = [anError objectForKey:@"Message"];
                } else {
                    errorMessage = @"An Error Occurred";
                }
            }
            else
            {
                errorMessage = @"An Error Occurred";
            }
            
             
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                              message: errorMessage                                                         delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        } else {

            
            // If the review request has gone through without errors, we're done.  Note the 
            //response and forward to the confirmation view.
            
            // In our case, it made sense to have the confirmation view be the only
            // view in the navigation stack, so that a back press would revert to the 
            // product view.  This may or may not be a best practice, depending on the
            // implementation.
            UINavigationController * navigationController = self.navigationController;
            [navigationController popToRootViewControllerAnimated:NO];        
            ConfirmViewController *confirmController = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmViewController"];
            
            // Forward the response data and image so that the confirmation page 
            // can display it.
            confirmController.confirmData = response.rawResponse;
            confirmController.reviewImage = self.previewImage;
            [navigationController pushViewController:confirmController animated:YES];

        }
    }
}

// This delegate method is called whenever we receive a progress update.  In this
// case, it indicates that we've received an update in the data sent uploading the 
// image.
- (void) didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite forRequest:(BVBase *)request
{
    // Update the progress bar.
    float percentage = (float) totalBytesWritten / (float) totalBytesExpectedToWrite;    
    self.progressBar.progress = percentage;
}

- (void) didFailToReceiveResponse:(NSError*)err forRequest:(BVBase *)request
{
    // Graceful handling of errors is critical.  In this case, we simply display a
    // prompt and pop the user back to the product screen so that they can submit 
    // again.
    [self.overlay setHidden:YES];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                      message:@"An error occurred.  Please try again."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validateFields {
    
    NSString *message;
    if(self.titleTextField.text.length == 0) {
        message = @"Please enter a title.";
    } else if(self.nicknameTextField.text.length == 0) {
        message = @"Please enter a nickname.";
    } else if(self.reviewTextView.text.length == 0) {
        message = @"Please enter a review.";
    } else if(self.rateView.rating == 0) {
        message = @"Please provide a star rating.";
    }
    
    if(message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" 
                                                        message:message
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return false;
    } else {
        return true;
    }
}

// This is the delegate method for the RateView to receive notifications
// that the rating has changed.  
- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
  // In this case, we do nothing, but in some cases this might be
  // useful, for instance, to update a rating label.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        return YES;    
    return NO;
}

@end
