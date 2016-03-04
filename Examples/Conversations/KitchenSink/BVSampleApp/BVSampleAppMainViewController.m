//
//  BVSampleAppMainViewController.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVSampleAppMainViewController.h"
#import <BVSDK/BVConversations.h>

@implementation BVSampleAppMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Examples";

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    myResultsView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - BVDelegate

- (void) didReceiveResponse:(NSDictionary *)response forRequest:(id)request {
    // When we get a response let's push the view controller response.
    NSLog(@"Raw Response: %@", response);
    
    // Only push if we haven't already pushed a view controller for a prior response (this handles a race condition
    // where two requests are sent before a response is received)
    if([self.navigationController topViewController] == self)
    {
        if (myResultsView == nil) {
            myResultsView = [[BVSampleAppResultsViewController alloc] init];
        }
        myResultsView.responseToDisplay = response;
        myResultsView.requestToSend = request;

        [self.navigationController pushViewController:myResultsView animated:YES];
    }
}

- (void) didFailToReceiveResponse:(NSError*)err forRequest:(id)request {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                      message:@"An error occurred. Please try again."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];

}

- (IBAction)showReview {
    BVGet *request = [[BVGet alloc] initWithType:BVGetTypeReviews];
    [request sendRequestWithDelegate:self];
}

- (IBAction)showQuestion {
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeQuestions];
    [showDisplayRequest sendRequestWithDelegate:self];
}

- (IBAction)showAnswers {
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeAnswers];
    [showDisplayRequest sendRequestWithDelegate:self];}

- (IBAction)showStory {
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeStories];
    [showDisplayRequest setFilterForAttribute:@"Id" equality:BVEqualityEqualTo value:@"14181"];
    [showDisplayRequest sendRequestWithDelegate:self];
}

- (IBAction)showComments {
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeReviewCommments];
    [showDisplayRequest sendRequestWithDelegate:self];  
}

- (IBAction)showCommentStory {
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeStoryCommments];
    [showDisplayRequest sendRequestWithDelegate:self];
}

- (IBAction)showProfile {
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeAuthors];
    [showDisplayRequest sendRequestWithDelegate:self];  
}

- (IBAction)showProducts {
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeProducts];
    [showDisplayRequest sendRequestWithDelegate:self];
}

- (IBAction)showCateogry {
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeCategories];
    [showDisplayRequest sendRequestWithDelegate:self];
}

- (IBAction)showStatistics {
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeStatistics];
    [showDisplayRequest setFilterForAttribute:@"ProductId" equality:BVEqualityEqualTo values:[NSArray arrayWithObjects:@"test1", @"test2", @"test3", nil]];
    [showDisplayRequest addStatsOn:BVIncludeStatsTypeReviews];
    [showDisplayRequest addStatsOn:BVIncludeStatsTypeNativeReviews];
    [showDisplayRequest sendRequestWithDelegate:self];
}

- (IBAction)submissionReview {
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
    
    BVPost *request = [[BVPost alloc] initWithType:BVPostTypeQuestion];
    request.categoryId = @"1020";
    request.locale = @"en_US";
    request.userId = @"123abcd";
    request.questionSummary =  @"Some kind of question";
    
    [request sendRequestWithDelegate:self];    
}

- (IBAction)submissionAnswers {
    
    BVPost *request = [[BVPost alloc] initWithType:BVPostTypeAnswer];
    request.questionId = @"6104";
    request.userId = @"123abcd";
    request.questionSummary =  @"Some kind of answer";
    
    [request sendRequestWithDelegate:self];
}

- (IBAction)submissionStories {
    
    BVPost *request = [[BVPost alloc] initWithType:BVPostTypeStory];
    request.title = @"This is the title";
    request.storyText = @"This is my story";
    request.categoryId = @"1020235";
    request.userId = @"123abc";
    
    [request sendRequestWithDelegate:self];
}

- (IBAction)submissionComments {
    BVPost *request = [[BVPost alloc] initWithType:BVPostTypeReviewComment];
    request.commentText = @"This is my comment text";
    request.reviewId = @"83964";
    request.userId = @"123abc";
    
    [request sendRequestWithDelegate:self];    
}
- (IBAction)submissionPhotos {
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
    BVPost *mySubmission = [[BVPost alloc] initWithType:BVPostTypeFeedback];
    mySubmission.contentType = BVFeedbackContentTypeReview;
    mySubmission.contentId = @"83964";
    mySubmission.userId = @"123abc";
    mySubmission.feedbackType = BVFeedbackTypeHelpfulness;
    mySubmission.vote = BVFeedbackVoteTypeNegative;
    [mySubmission sendRequestWithDelegate:self];
}

@end