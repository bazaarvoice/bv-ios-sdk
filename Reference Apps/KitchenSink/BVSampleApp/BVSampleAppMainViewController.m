//
//  BVSampleAppMainViewController.m
//  BVSampleApp
//
//  Created by Bazaarvoice Engineering on 3/10/12.
//  Copyright (c) 2012 Bazaarvoice Inc.. All rights reserved.
//

#import "BVSampleAppMainViewController.h"
#import "BVSettings.h"
#import "BVConstants.h"
#import "BVGet.h"
#import "BVPost.h"
#import "BVMediaPost.h"

@interface BVSampleAppMainViewController () {
    BOOL isVisible;    
}
@end

@implementation BVSampleAppMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGSize mySize;
    UIScrollView *setContentSize = (UIScrollView*)self.view;
    mySize.width = self.view.bounds.size.width;
    mySize.height = self.view.bounds.size.height;
    setContentSize.contentSize = mySize;
    [BVSettings instance].passKey = @"2cpdrhohmgmwfz8vqyo48f52g";
    [BVSettings instance].staging = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    isVisible = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    myResultsView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - BVDelegate

- (void) didReceiveResponse:(NSDictionary *)response forRequest:(id)request {
    // When we get a response let's push the view controller response.
    NSLog(@"Raw Response: %@", response);
    
    // Only push if we haven't already pushed a view controller for a prior response (this handles a race condition
    // where two requests are sent before a response is received)
    if (isVisible) {
        if (myResultsView == nil) {
            myResultsView = [[BVSampleAppResultsViewController alloc] init];
        }
        myResultsView.responseToDisplay = response;
        myResultsView.requestToSend = request;
        isVisible = NO;
        [self.navigationController pushViewController:myResultsView animated:YES];
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void) didFailToReceiveResponse:(NSError*)err forRequest:(id)request {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                      message:@"An error occurred.  Please try again."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];

}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(BVSampleAppFlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    BVSampleAppFlipsideViewController *controller = [[BVSampleAppFlipsideViewController alloc] initWithNibName:@"BVSampleAppFlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)showReview {
    [BVSettings instance].baseURL = @"reviews.apitestcustomer.bazaarvoice.com";
    BVGet *request = [[BVGet alloc] initWithType:BVGetTypeReviews];
    [request sendRequestWithDelegate:self];
}

- (IBAction)showQuestion {
    [BVSettings instance].baseURL = @"answers.apitestcustomer.bazaarvoice.com";
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeQuestions];
    [showDisplayRequest sendRequestWithDelegate:self];
}

- (IBAction)showAnswers {
    [BVSettings instance].baseURL = @"answers.apitestcustomer.bazaarvoice.com";
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeAnswers];
    [showDisplayRequest sendRequestWithDelegate:self];}

- (IBAction)showStory {
    [BVSettings instance].baseURL = @"stories.apitestcustomer.bazaarvoice.com";
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeStories];
    [showDisplayRequest setFilterForAttribute:@"Id" equality:BVEqualityEqualTo value:@"14181"];
    [showDisplayRequest sendRequestWithDelegate:self];
}

- (IBAction)showComments {
    [BVSettings instance].baseURL = @"reviews.apitestcustomer.bazaarvoice.com";
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeReviewCommments];
    [showDisplayRequest sendRequestWithDelegate:self];  
}

- (IBAction)showCommentStory {
    [BVSettings instance].baseURL = @"stories.apitestcustomer.bazaarvoice.com";
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeStoryCommments];
    [showDisplayRequest sendRequestWithDelegate:self];

}

- (IBAction)showProfile {
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeAuthors];
    [showDisplayRequest sendRequestWithDelegate:self];  
}

- (IBAction)showProducts {
    [BVSettings instance].baseURL = @"reviews.apitestcustomer.bazaarvoice.com";
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeProducts];
    [showDisplayRequest sendRequestWithDelegate:self];
}

- (IBAction)showCateogry {
    [BVSettings instance].baseURL = @"reviews.apitestcustomer.bazaarvoice.com";
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeCategories];
    [showDisplayRequest sendRequestWithDelegate:self];
}

- (IBAction)showStatistics {
    [BVSettings instance].baseURL = @"reviews.apitestcustomer.bazaarvoice.com";
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeStatistics];
    [showDisplayRequest setFilterForAttribute:@"ProductId" equality:BVEqualityEqualTo values:[NSArray arrayWithObjects:@"test1", @"test2", @"test3", nil]];
    [showDisplayRequest addStatsOn:BVIncludeStatsTypeReviews];
    [showDisplayRequest addStatsOn:BVIncludeStatsTypeNativeReviews];
    [showDisplayRequest sendRequestWithDelegate:self];
}

- (IBAction)submissionReview {
    [BVSettings instance].baseURL = @"reviews.apitestcustomer.bazaarvoice.com";
    BVPost *request = [[BVPost alloc] initWithType:BVPostTypeReview];
    request.productId = @"100003401";
    request.userId = @"123abcd";
    request.rating = 5;
    request.title = @"Test title";
    request.reviewText = @"Some kind of review text.";
    request.userNickname = @"testnickname";
    [request addPhotoUrl:@"http://apitestcustomer.ugc.bazaarvoice.com/bvstaging/5555/ps_amazon_s3_3rgg6s4xvev0zhzbnabyneo21/photo.jpg" withCaption:nil];
    [request addVideoUrl:@"http://www.youtube.com" withCaption:nil];
    [request sendRequestWithDelegate:self];
}

- (IBAction)submissionQuestions {
    [BVSettings instance].baseURL = @"answers.apitestcustomer.bazaarvoice.com";
    
    BVPost *request = [[BVPost alloc] initWithType:BVPostTypeQuestion];
    request.categoryId = @"1020";
    request.locale = @"en_US";
    request.userId = @"123abcd";
    request.questionSummary =  @"Some kind of question";
    
    [request sendRequestWithDelegate:self];    
}

- (IBAction)submissionAnswers {
    [BVSettings instance].baseURL = @"answers.apitestcustomer.bazaarvoice.com";
    
    BVPost *request = [[BVPost alloc] initWithType:BVPostTypeAnswer];
    request.questionId = @"6104";
    request.userId = @"123abcd";
    request.questionSummary =  @"Some kind of answer";
    
    [request sendRequestWithDelegate:self];
}

- (IBAction)submissionStories {
    [BVSettings instance].baseURL = @"stories.apitestcustomer.bazaarvoice.com";
    
    BVPost *request = [[BVPost alloc] initWithType:BVPostTypeStory];
    request.title = @"This is the title";
    request.storyText = @"This is my story";
    request.categoryId = @"1020235";
    request.userId = @"123abc";
    
    [request sendRequestWithDelegate:self];
}

- (IBAction)submissionComments {
    [BVSettings instance].baseURL = @"reviews.apitestcustomer.bazaarvoice.com";
    BVPost *request = [[BVPost alloc] initWithType:BVPostTypeReviewComment];
    request.commentText = @"This is my comment text";
    request.reviewId = @"83964";
    request.userId = @"123abc";
    
    [request sendRequestWithDelegate:self];    
}
- (IBAction)submissionPhotos {
    [BVSettings instance].baseURL = @"reviews.apitestcustomer.bazaarvoice.com";
    BVMediaPost *mySubmission = [[BVMediaPost alloc] initWithType:BVMediaPostTypePhoto];
    mySubmission.contentType = BVMediaPostContentTypeReview;
    mySubmission.userId = @"123";
    
    UIImage *image = [UIImage imageNamed:@"bv533x533.png"];
    mySubmission.photo = image;
    
    [mySubmission sendRequestWithDelegate:self];
}

- (IBAction)submissionVideos {
    BVMediaPost *mySubmission = [[BVMediaPost alloc] initWithType:BVMediaPostTypeVideo];
    mySubmission.contentType = BVMediaPostContentTypeReview;
    mySubmission.userId = @"123";
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *videoPath = [bundle pathForResource:@"sample_mpeg4" ofType:@"mp4"];
    NSData *video = [NSData dataWithContentsOfFile:videoPath];
    [mySubmission setVideo:video withFormat:BVVideoFormatTypeMP4];
    [mySubmission sendRequestWithDelegate:self];
}

- (IBAction)submissionFeedback {
    [BVSettings instance].baseURL = @"reviews.apitestcustomer.bazaarvoice.com";
    BVPost *mySubmission = [[BVPost alloc] initWithType:BVPostTypeFeedback];
    mySubmission.contentType = BVFeedbackContentTypeReview;
    mySubmission.contentId = @"83964";
    mySubmission.userId = @"123abc";
    mySubmission.feedbackType = BVFeedbackTypeHelpfulness;
    mySubmission.vote = BVFeedbackVoteTypeNegative;
    [mySubmission sendRequestWithDelegate:self];
}

@end