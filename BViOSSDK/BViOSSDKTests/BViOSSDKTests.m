//
//  BViOSSDKTests.m
//  BViOSSDKTests
//
//  Created by Bazaarvoice Engineering on 3/13/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BViOSSDKTests.h"

@implementation BViOSSDKTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void) didReceiveResponse:(BVResponse *)response forRequest:(BVBase *)request {
    NSLog(@"\n\n");
    requestComplete = YES;
    if (response.hasErrors) {
        NSLog(@"\n\n==========================\n\n");
        STFail(@"Error in Class: %@ \n Failure: %@", [request class], response.errors);
        NSLog(@"\n\n==========================\n\n");
    }
    else {
        STAssertNotNil(response.rawResponse, @"Invalid response for Class: %@", [request class]);
    }
    NSLog(@"\n\n");
}


- (void)testShowReview {
    requestComplete = NO;
    BVDisplayReview *showDisplayRequest = [[BVDisplayReview alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"Id:192612";
    showDisplayRequest.parameters.include = @"Products";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testShowQuestion {
    requestComplete = NO;
    BVDisplayQuestion *showDisplayRequest = [[BVDisplayQuestion alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"Id:14898";
    showDisplayRequest.parameters.include = @"Answers";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testShowAnswers {
    requestComplete = NO;
    BVDisplayAnswer *showDisplayRequest = [[BVDisplayAnswer alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"Id:16369";
    showDisplayRequest.parameters.include = @"Questions";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testShowStory {
    requestComplete = NO;
    BVDisplayStories *showDisplayRequest = [[BVDisplayStories alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"ProductId:1000001";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);    
}

- (void)testShowComments {
    requestComplete = NO;
    BVDisplayReviewComment *showDisplayRequest = [[BVDisplayReviewComment alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"reviewid:192548";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);    
}

- (void)testShowCommentStory {
    requestComplete = NO;
    BVDisplayStoryComment *showDisplayRequest = [[BVDisplayStoryComment alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"storyid:1593";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testShowProfile {
    requestComplete = NO;
    BVDisplayProfile *showDisplayRequest = [[BVDisplayProfile alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"TotalCommentCount:gte:20";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testShowProducts {
    requestComplete = NO;
    BVDisplayProducts *showDisplayRequest = [[BVDisplayProducts alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"CategoryId:eq:testcategory1011";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testShowCateogry {
    requestComplete = NO;
    BVDisplayCategories *showDisplayRequest = [[BVDisplayCategories alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"id:testCategory1011";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}


- (void)testShowStatistics {
    requestComplete = NO;
    BVDisplayStatistics *showDisplayRequest = [[BVDisplayStatistics alloc] init];
    [BVSettings instance].passKey = @"KEY_REMOVED";
    showDisplayRequest.parameters.filter = @"productid:test1,test2,test3";
    showDisplayRequest.parameters.stats = @"Reviews,NativeReviews";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}


- (void)testSubmissionReview {
    requestComplete = NO;
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
    [mySubmission startAsynchRequest];                                
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testSubmissionQuestions {
    requestComplete = NO;
    BVSubmissionQuestion *mySubmission = [[BVSubmissionQuestion alloc] init];
    mySubmission.parameters.categoryId = @"1020";
    mySubmission.parameters.locale = @"en_US";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.parameters.questionSummary = @"Some kind of summary";
    mySubmission.delegate = self;
    
    [BVSettings instance].passKey = @"KEY_REMOVED";
    NSString *temp = [BVSettings instance].customerName;
    [BVSettings instance].customerName = @"answers.apitestcustomer";
    
    [mySubmission startAsynchRequest];                    
    [BVSettings instance].customerName = temp;

    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testSubmissionAnswers {
    requestComplete = NO;
    BVSubmissionAnswer *mySubmission = [[BVSubmissionAnswer alloc] init];
    mySubmission.parameters.questionId = @"6104";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.parameters.answerText = @"Some kind of answer";
    mySubmission.delegate = self;
    [BVSettings instance].passKey = @"KEY_REMOVED";
    NSString *temp = [BVSettings instance].customerName;
    [BVSettings instance].customerName = @"answers.apitestcustomer";

    
    [mySubmission startAsynchRequest];    
    [BVSettings instance].customerName = temp;

    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testSubmissionStories {
    requestComplete = NO;
    BVSubmissionStory *mySubmission = [[BVSubmissionStory alloc] init];
    mySubmission.parameters.title = @"This is the title";
    mySubmission.parameters.storyText = @"This is my story";
    mySubmission.parameters.categoryId = @"1020";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.delegate = self;
    [BVSettings instance].customerName = @"stories.apitestcustomer";
    [BVSettings instance].passKey = @"KEY_REMOVED";
    
    [mySubmission startAsynchRequest];        
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testSubmissionComments {
    requestComplete = NO;
    BVSubmissionReviewComment *mySubmission = [[BVSubmissionReviewComment alloc] init];    
    mySubmission.parameters.commentText = @"This is my comment text";
    mySubmission.parameters.reviewId = @"83964";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.delegate = self;
    [BVSettings instance].passKey = @"KEY_REMOVED";
    
    [mySubmission startAsynchRequest];            
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}


- (void)testSubmissionVideos {
    requestComplete = NO;
    BVSubmissionVideo *mySubmission = [[BVSubmissionVideo alloc] init];    
    mySubmission.parameters.contentType = @"review";
    mySubmission.parameters.video = @"http://www.youtube.com/";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.delegate = self;
    [BVSettings instance].passKey = @"KEY_REMOVED";
    [BVSettings instance].customerName = @"reviews.apitestcustomer";

    [mySubmission startAsynchRequest];                
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}



- (void)testSubmissionPhotos {

    requestComplete = NO;
    BVSubmissionPhoto *mySubmission = [[BVSubmissionPhoto alloc] init];
    mySubmission.parameters.contentType = @"review";
    mySubmission.parameters.userId = @"123";
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"bv533x533" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    mySubmission.parameters.photo = image;
    mySubmission.delegate = self;
    [BVSettings instance].passKey = @"f5jyj7alrfvm7hh3mbykot8ui";
    [BVSettings instance].apiVersion = @"5.1";
    [BVSettings instance].customerName = @"reviews.apitestcustomer";
    [mySubmission startAsynchRequest];                
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
}




@end