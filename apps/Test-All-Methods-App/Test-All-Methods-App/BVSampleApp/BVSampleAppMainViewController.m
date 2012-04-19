//
//  BVSampleAppMainViewController.m
//  BVSampleApp
//
//  Created by Bazaarvoice Engineering on 3/10/12.
//  Copyright (c) 2012 Bazaarvoice Inc.. All rights reserved.
//

#import "BVSampleAppMainViewController.h"

@interface BVSampleAppMainViewController ()

@end

@implementation BVSampleAppMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGSize mySize;
    self.title = @"BV API Calls";
    UIScrollView *setContentSize = (UIScrollView*)self.view;
    mySize.width = 320.0;
    mySize.height = 500.0;
    setContentSize.contentSize = mySize;
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

- (void) didReceiveResponse:(BVResponse *)response sender:(BVBase *)senderID {
    // When we get a response let's push the view controller response.
    NSLog(@"Raw Response: %@", response.rawResponse);
    if (myResultsView == nil) {
        myResultsView = [[BVSampleAppResultsViewController alloc] init];
    }
    
    myResultsView.responseToDisplay = response;
    [self.navigationController pushViewController:myResultsView animated:YES];
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
    BVDisplayReview *showDisplayRequest = [[BVDisplayReview alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"Id:192612";
    showDisplayRequest.parameters.include = @"Products";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
}

- (IBAction)showQuestion {
    BVDisplayQuestion *showDisplayRequest = [[BVDisplayQuestion alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"Id:14898";
    showDisplayRequest.parameters.include = @"Answers";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
}

- (IBAction)showAnswers {
    BVDisplayAnswer *showDisplayRequest = [[BVDisplayAnswer alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"Id:16369";
    showDisplayRequest.parameters.include = @"Questions";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
}

- (IBAction)showStory {
    BVDisplayStories *showDisplayRequest = [[BVDisplayStories alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"ProductId:1000001";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
}

- (IBAction)showComments {
    BVDisplayReviewComment *showDisplayRequest = [[BVDisplayReviewComment alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"reviewid:192548";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];    
}

- (IBAction)showCommentStory {
    BVDisplayStoryComment *showDisplayRequest = [[BVDisplayStoryComment alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"storyid:1593";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];    
}

- (IBAction)showProfile {
    BVDisplayProfile *showDisplayRequest = [[BVDisplayProfile alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"TotalCommentCount:gte:20";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];    
}

- (IBAction)showProducts {
    BVDisplayProducts *showDisplayRequest = [[BVDisplayProducts alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"CategoryId:eq:testcategory1011";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
}

- (IBAction)showCateogry {
    BVDisplayCategories *showDisplayRequest = [[BVDisplayCategories alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"id:testCategory1011";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
}

- (IBAction)submissionReview {
    BVSubmissionReview *mySubmission = [[BVSubmissionReview alloc] init];
    mySubmission.parameters.productId = @"1000001";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.parameters.rating = @"5";
    mySubmission.parameters.title = @"Test title";
    mySubmission.parameters.reviewText = @"Some kind of review text.";
    mySubmission.parameters.userNickName = @"testnickname";
    mySubmission.parameters.videoUrl.typeName = @"1";
    mySubmission.parameters.videoUrl.typeValue = @"http://www.youtube.com/";
    mySubmission.delegate = self;
    [BVSettings instance].passKey = @"u16cwr987fkx0hprzhrbqbmqo";
    [mySubmission startAsynchRequest];                                  
}

- (IBAction)submissionQuestions {
    BVSubmissionQuestion *mySubmission = [[BVSubmissionQuestion alloc] init];
    mySubmission.parameters.categoryId = @"1020";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.parameters.questionSummary = @"Some kind of summary";
    mySubmission.delegate = self;
    [BVSettings instance].passKey = @"u16cwr987fkx0hprzhrbqbmqo";
    
    [mySubmission startAsynchRequest];                                  
}

- (IBAction)submissionAnswers {
    BVSubmissionAnswer *mySubmission = [[BVSubmissionAnswer alloc] init];
    mySubmission.parameters.questionId = @"6104";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.parameters.answerText = @"Some kind of answer";
    mySubmission.delegate = self;
    [BVSettings instance].passKey = @"KEY_REMOVED";
    
    [mySubmission startAsynchRequest];    
}

- (IBAction)submissionStories {
    BVSubmissionStory *mySubmission = [[BVSubmissionStory alloc] init];
    mySubmission.parameters.title = @"This is the title";
    mySubmission.parameters.storyText = @"This is my story";
    mySubmission.parameters.categoryId = @"1020";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.delegate = self;
    [BVSettings instance].passKey = @"KEY_REMOVED";
    
    [mySubmission startAsynchRequest];        
}

- (IBAction)submissionComments {
    BVSubmissionReviewComment *mySubmission = [[BVSubmissionReviewComment alloc] init];    
    mySubmission.parameters.commentText = @"This is my comment text";
    mySubmission.parameters.reviewId = @"83964";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.delegate = self;
    [BVSettings instance].passKey = @"KEY_REMOVED";
    
    [mySubmission startAsynchRequest];            
}
- (IBAction)submissionPhotos {
    BVSubmissionPhoto *mySubmission = [[BVSubmissionPhoto alloc] init];
    mySubmission.parameters.contentType = @"story";
    mySubmission.parameters.userId = @"testuserid111";
    mySubmission.parameters.photo = [UIImage imageNamed:@"SmallPic.jpg"];
    mySubmission.delegate = self;
    [BVSettings instance].passKey = @"u16cwr987fkx0hprzhrbqbmqo";//@"62x52tk0usyejqc0yqtx8jtc6";
    [BVSettings instance].apiVersion = @"5.1";
    NSString *temp = [BVSettings instance].customerName;
    [BVSettings instance].customerName = @"directbuy.ugc";
    [mySubmission startAsynchRequest];                                     
    [BVSettings instance].customerName = temp;
}

- (IBAction)submissionVideos {
    BVSubmissionVideo *mySubmission = [[BVSubmissionVideo alloc] init];    
    mySubmission.parameters.contentType = @"review";
    mySubmission.parameters.video = @"http://www.youtube.com/";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.delegate = self;
    [BVSettings instance].passKey = @"KEY_REMOVED";
    
    [mySubmission startAsynchRequest];                
}

@end