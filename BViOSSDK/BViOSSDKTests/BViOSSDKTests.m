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
    [BVSettings instance].customerName = @"reviews.apitestcustomer";
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)checkParams:(NSMutableDictionary *)params {
    NSString *url = sentRequest.rawURLRequest;
    NSDictionary *baseDictionary = [NSDictionary 
                                    dictionaryWithObjectsAndKeys:[BVSettings instance].apiVersion,
                                    @"apiversion", 
                                    [BVSettings instance].passKey, 
                                    @"passkey",
                                    nil];
    [params addEntriesFromDictionary:baseDictionary];
    NSMutableDictionary *foundParams = [[NSMutableDictionary alloc] init];
    NSArray *comp1 = [url componentsSeparatedByString:@"?"];
    NSString *query = [comp1 lastObject];
    NSArray *queryElements = [query componentsSeparatedByString:@"&"];
    for (NSString *element in queryElements) {
        NSArray *keyVal = [element componentsSeparatedByString:@"="];
        NSAssert(keyVal.count == 2, @"Malformed URL");
        [foundParams setObject:[keyVal objectAtIndex:1] forKey:[keyVal objectAtIndex:0]];
    }
    
    NSAssert(params.count == foundParams.count, @"Wrong number of URL params");
    
    NSArray *keyArray = [params allKeys];
    int count = [keyArray count];
    for (int i=0; i < count; i++) {
        NSString * key = [keyArray objectAtIndex:i];
        NSAssert([foundParams objectForKey:key], @"Request missing parameter %@", key);
        NSString *requestVal = (NSString *)[foundParams objectForKey:key];
        NSString *expectedVal = (NSString *)[params objectForKey:key];
        NSAssert([requestVal isEqualToString:expectedVal], @"Request value of %@ does not match expected value of %@", requestVal, expectedVal);
    }
}

- (void) didReceiveResponse:(BVResponse *)response forRequest:(BVBase *)request {
    NSLog(@"\n\n");
    requestComplete = YES;
    receivedResponse = response;
    sentRequest = request;
    if (response.hasErrors) {
        NSLog(@"\n\n==========================\n\n");
        STFail(@"Error in Class: %@ \n Failure: %@", [request class], response.errors);
        NSLog(@"\n\n==========================\n\n");
    }
    else if(!receivedProgressCallback && [request isKindOfClass:[BVSubmission class]])
    {
        // We only need to check if we received a progress callback for POST / submission requests
        NSLog(@"\n\n==========================\n\n");
        STFail(@"Failed to receive a progress callback for request: %@", [request class]);
        NSLog(@"\n\n==========================\n\n");
    }
    else 
    {
        STAssertNotNil(response.rawResponse, @"Invalid response for Class: %@", [request class]);
    }
    NSLog(@"\n\n");
}

- (void) didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite forRequest:(BVBase*)request 
{
    STAssertTrue(bytesWritten <= totalBytesWritten, 
                 @"bytesWritten should be less than totalBytesWritten");
    
    STAssertTrue(totalBytesWritten <= totalBytesExpectedToWrite, 
                 @"totalBytesWritten should be less than totalBytesExpectedToWrite");
    receivedProgressCallback = YES;
}

- (void) didFailToReceiveResponse:(NSError *)err forRequest:(BVBase *)request
{
    requestComplete = YES;
    NSLog(@"\n\n==========================\n\n");
    STFail(@"Request failed to receive response: %@", [request class]);
    NSLog(@"\n\n==========================\n\n");
}


- (void)testShowReviewSparse {
    requestComplete = NO;
    BVDisplayReview *showDisplayRequest = [[BVDisplayReview alloc] init];
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]];     
}


- (void)testShowReview {
    requestComplete = NO;
    BVDisplayReview *showDisplayRequest = [[BVDisplayReview alloc] init];
    showDisplayRequest.parameters.filter = @"Id:6601211";
    [showDisplayRequest.parameters.filterType addKey:@"products" andValue:@"id:009"];
    showDisplayRequest.parameters.include = @"Products";
    showDisplayRequest.parameters.limit = @"50";
    [showDisplayRequest.parameters.limitType addKey:@"products" andValue:@"10"];
    showDisplayRequest.parameters.offset = @"0";
    showDisplayRequest.parameters.sort = @"id:asc";
    [showDisplayRequest.parameters.sortType addKey:@"products" andValue:@"id:asc"];
    showDisplayRequest.parameters.stats = @"reviews";
    showDisplayRequest.parameters.search = @"Great sound";
    
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"reviews", @"stats", @"id:asc", @"Sort_products", @"id:009", @"Filter_products", @"10", @"Limit_products", @"id:asc", @"sort", @"Products", @"include", @"0", @"offset", @"Id:6601211", @"filter", @"50", @"limit", @"Great%20sound", @"search", nil]];     
}
              
- (void)testShowQuestionSparse {
    [BVSettings instance].customerName = @"answers.apitestcustomer";
    requestComplete = NO;
    BVDisplayQuestion *showDisplayRequest = [[BVDisplayQuestion alloc] init];
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]];     
}

- (void)testShowQuestion {
    [BVSettings instance].customerName = @"answers.apitestcustomer";
    requestComplete = NO;
    BVDisplayQuestion *showDisplayRequest = [[BVDisplayQuestion alloc] init];
    
    showDisplayRequest.parameters.filter = @"Id:87757";
    [showDisplayRequest.parameters.filterType addKey:@"products" andValue:@"id:test1"];
    showDisplayRequest.parameters.include = @"Products";
    showDisplayRequest.parameters.limit = @"50";
    [showDisplayRequest.parameters.limitType addKey:@"products" andValue:@"10"];
    showDisplayRequest.parameters.offset = @"0";
    showDisplayRequest.parameters.sort = @"id:asc";
    [showDisplayRequest.parameters.sortType addKey:@"products" andValue:@"id:asc"];
    showDisplayRequest.parameters.stats = @"reviews";

    
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"reviews", @"stats", @"id:asc", @"Sort_products", @"id:test1", @"Filter_products", @"10", @"Limit_products", @"id:asc", @"sort", @"Products", @"include", @"0", @"offset", @"Id:87757", @"filter", @"50", @"limit", nil]];     
    

}

- (void)testShowAnswersSparse {
    [BVSettings instance].customerName = @"answers.apitestcustomer";
    requestComplete = NO;
    BVDisplayAnswer *showDisplayRequest = [[BVDisplayAnswer alloc] init];
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]];     
}


- (void)testShowAnswers {
    [BVSettings instance].customerName = @"answers.apitestcustomer";
    requestComplete = NO;
    BVDisplayAnswer *showDisplayRequest = [[BVDisplayAnswer alloc] init];
    
    showDisplayRequest.parameters.filter = @"Id:6055";
    [showDisplayRequest.parameters.filterType addKey:@"products" andValue:@"id:test0"];
    showDisplayRequest.parameters.include = @"Products";
    showDisplayRequest.parameters.limit = @"50";
    [showDisplayRequest.parameters.limitType addKey:@"products" andValue:@"10"];
    showDisplayRequest.parameters.offset = @"0";
    showDisplayRequest.parameters.sort = @"id:asc";
    [showDisplayRequest.parameters.sortType addKey:@"products" andValue:@"id:asc"];
    showDisplayRequest.parameters.stats = @"Answers";
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);

    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"Answers", @"stats", @"id:asc", @"Sort_products", @"id:test0", @"Filter_products", @"10", @"Limit_products", @"id:asc", @"sort", @"Products", @"include", @"0", @"offset", @"Id:6055", @"filter", @"50", @"limit", nil]];
}

- (void)testShowStorySparse {
    [BVSettings instance].customerName = @"stories.apitestcustomer";
    requestComplete = NO;
    BVDisplayStories *showDisplayRequest = [[BVDisplayStories alloc] init];
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);    
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]];     
}

- (void)testShowStory {
    [BVSettings instance].customerName = @"stories.apitestcustomer";
    requestComplete = NO;
    BVDisplayStories *showDisplayRequest = [[BVDisplayStories alloc] init];
    showDisplayRequest.parameters.filter = @"Id:14181";
    [showDisplayRequest.parameters.filterType addKey:@"Comments" andValue:@"id:1010"];
    showDisplayRequest.parameters.include = @"Comments";
    showDisplayRequest.parameters.limit = @"50";
    [showDisplayRequest.parameters.limitType addKey:@"Comments" andValue:@"10"];
    showDisplayRequest.parameters.offset = @"0";
    showDisplayRequest.parameters.sort = @"id:asc";
    [showDisplayRequest.parameters.sortType addKey:@"Comments" andValue:@"id:asc"];
    showDisplayRequest.parameters.stats = @"Stories";
    showDisplayRequest.delegate = self;

    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);    
    
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"Stories", @"stats", @"id:asc", @"Sort_Comments", @"id:1010", @"Filter_Comments", @"10", @"Limit_Comments", @"id:asc", @"sort", @"Comments", @"include", @"0", @"offset", @"Id:14181", @"filter", @"50", @"limit", nil]];     
}


- (void)testShowCommentsSparse {
    requestComplete = NO;
    BVDisplayReviewComment *showDisplayRequest = [[BVDisplayReviewComment alloc] init];
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);   
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]];     
}

- (void)testShowComments {
    requestComplete = NO;
    BVDisplayReviewComment *showDisplayRequest = [[BVDisplayReviewComment alloc] init];
    showDisplayRequest.delegate = self;
    showDisplayRequest.parameters.filter = @"reviewid:6597809";
    [showDisplayRequest.parameters.filterType addKey:@"products" andValue:@"id:2323001"];
    showDisplayRequest.parameters.include = @"Products";
    showDisplayRequest.parameters.limit = @"50";
    [showDisplayRequest.parameters.limitType addKey:@"products" andValue:@"10"];
    showDisplayRequest.parameters.offset = @"0";
    showDisplayRequest.parameters.sort = @"id:asc";
    [showDisplayRequest.parameters.sortType addKey:@"products" andValue:@"id:asc"];
    showDisplayRequest.parameters.stats = @"reviews";

    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]); 
    
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"reviews", @"stats", @"id:asc", @"Sort_products", @"id:2323001", @"Filter_products", @"10", @"Limit_products", @"id:asc", @"sort", @"Products", @"include", @"0", @"offset", @"reviewid:6597809", @"filter", @"50", @"limit", nil]];     
}

- (void)testShowCommentStorySparse {
    [BVSettings instance].customerName = @"stories.apitestcustomer";    
    requestComplete = NO;
    BVDisplayStoryComment *showDisplayRequest = [[BVDisplayStoryComment alloc] init];
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]];     

}

- (void)testShowCommentStory {
    [BVSettings instance].customerName = @"stories.apitestcustomer";    
    requestComplete = NO;
    BVDisplayStoryComment *showDisplayRequest = [[BVDisplayStoryComment alloc] init];
    showDisplayRequest.parameters.filter = @"storyid:967";
    [showDisplayRequest.parameters.filterType addKey:@"products" andValue:@"id:test1"];
    showDisplayRequest.parameters.include = @"Products";
    showDisplayRequest.parameters.limit = @"10";
    [showDisplayRequest.parameters.limitType addKey:@"products" andValue:@"10"];
    showDisplayRequest.parameters.offset = @"0";
    showDisplayRequest.parameters.sort = @"id:asc";
    [showDisplayRequest.parameters.sortType addKey:@"products" andValue:@"id:asc"];
    showDisplayRequest.parameters.stats = @"reviews";

    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"reviews", @"stats", @"id:asc", @"Sort_products", @"id:test1", @"Filter_products", @"10", @"Limit_products", @"id:asc", @"sort", @"Products", @"include", @"0", @"offset", @"storyid:967", @"filter", @"10", @"limit", nil]];     
}

- (void)testShowProfileSparse {
    requestComplete = NO;
    BVDisplayProfile *showDisplayRequest = [[BVDisplayProfile alloc] init];
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);

    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]];     
}

- (void)testShowProfile {
    requestComplete = NO;
    BVDisplayProfile *showDisplayRequest = [[BVDisplayProfile alloc] init];
    showDisplayRequest.parameters.filter = @"TotalCommentCount:gte:0";
    showDisplayRequest.delegate = self;
    
    showDisplayRequest.parameters.filter = @"id:smartPP";
    showDisplayRequest.parameters.limit = @"10";
    showDisplayRequest.parameters.offset = @"0";
    showDisplayRequest.parameters.sort = @"id:asc";
    showDisplayRequest.parameters.stats = @"reviews";
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"reviews", @"stats", @"id:asc", @"sort",  @"0", @"offset", @"id:smartPP", @"filter", @"10", @"limit", nil]];     
}

- (void)testShowProductsSparse {
    requestComplete = NO;
    BVDisplayProducts *showDisplayRequest = [[BVDisplayProducts alloc] init];
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]];     
}

- (void)testShowProducts {
    requestComplete = NO;
    BVDisplayProducts *showDisplayRequest = [[BVDisplayProducts alloc] init];
    showDisplayRequest.parameters.filter = @"CategoryId:eq:testcategory1011";
    [showDisplayRequest.parameters.filterType addKey:@"Reviews" andValue:@"id:83501"];
    showDisplayRequest.parameters.include = @"Reviews";
    showDisplayRequest.parameters.limit = @"10";
    [showDisplayRequest.parameters.limitType addKey:@"Reviews" andValue:@"10"];
    showDisplayRequest.parameters.offset = @"0";
    showDisplayRequest.parameters.sort = @"id:asc";
    [showDisplayRequest.parameters.sortType addKey:@"Reviews" andValue:@"id:asc"];
    showDisplayRequest.parameters.stats = @"reviews";

    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"reviews", @"stats", @"id:asc", @"Sort_Reviews", @"id:83501", @"Filter_Reviews", @"10", @"Limit_Reviews", @"id:asc", @"sort", @"Reviews", @"include", @"0", @"offset", @"CategoryId:eq:testcategory1011", @"filter", @"10", @"limit", nil]];     
}

- (void)testShowCateogrySparse {
    requestComplete = NO;
    BVDisplayCategories *showDisplayRequest = [[BVDisplayCategories alloc] init];
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]];     
}

- (void)testShowCateogry {
    requestComplete = NO;
    BVDisplayCategories *showDisplayRequest = [[BVDisplayCategories alloc] init];
    showDisplayRequest.parameters.filter = @"id:testCategory1011";
    [showDisplayRequest.parameters.filterType addKey:@"products" andValue:@"id:test2"];
    showDisplayRequest.parameters.include = @"Products";
    showDisplayRequest.parameters.limit = @"10";
    [showDisplayRequest.parameters.limitType addKey:@"products" andValue:@"10"];
    showDisplayRequest.parameters.offset = @"0";
    showDisplayRequest.parameters.sort = @"id:asc";
    [showDisplayRequest.parameters.sortType addKey:@"products" andValue:@"id:asc"];
    showDisplayRequest.parameters.stats = @"reviews";
    
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    [self checkParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"reviews", @"stats", @"id:asc", @"Sort_products", @"id:test2", @"Filter_products", @"10", @"Limit_products", @"id:asc", @"sort", @"Products", @"include", @"0", @"offset", @"id:testCategory1011", @"filter", @"10", @"limit", nil]];     
    showDisplayRequest.delegate = self;
    
    [showDisplayRequest startAsynchRequest];
}

- (void)testShowStatistics {
    requestComplete = NO;
    BVDisplayStatistics *showDisplayRequest = [[BVDisplayStatistics alloc] init];
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
    receivedProgressCallback = NO;
    BVSubmissionReview *mySubmission = [[BVSubmissionReview alloc] init];
    mySubmission.parameters.productId = @"100003401";
    mySubmission.parameters.userId = @"123abcd";
    mySubmission.parameters.rating = @"5";
    mySubmission.parameters.title = @"Test title";
    mySubmission.parameters.reviewText = @"Some kind of review text.";
    mySubmission.parameters.userNickName = @"testnickname";
    [mySubmission.parameters.videoUrl addKey:@"1" andValue:@"http://www.youtube.com/"];
    [mySubmission.parameters.photoURL addKey:@"1" andValue:@"http://apitestcustomer.ugc.bazaarvoice.com/bvstaging/5555/ps_amazon_s3_3rgg6s4xvev0zhzbnabyneo21/photo.jpg"];
    [mySubmission.parameters.tag addKey:@"JeanSize" andValue:@"small"];
    mySubmission.delegate = self;
    [mySubmission startAsynchRequest];                                
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testSubmissionQuestions {
    [BVSettings instance].customerName = @"answers.apitestcustomer";
    requestComplete = NO;
    receivedProgressCallback = NO;
    BVSubmissionQuestion *mySubmission = [[BVSubmissionQuestion alloc] init];
    mySubmission.parameters.categoryId = @"1020";
    mySubmission.parameters.locale = @"en_US";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.parameters.questionSummary = @"Some kind of summary";
    mySubmission.delegate = self;
    [mySubmission startAsynchRequest];                    

    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testSubmissionAnswers {
    [BVSettings instance].customerName = @"answers.apitestcustomer";
    requestComplete = NO;
    BVSubmissionAnswer *mySubmission = [[BVSubmissionAnswer alloc] init];
    mySubmission.parameters.questionId = @"6104";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.parameters.answerText = @"Some kind of answer";
    mySubmission.delegate = self;
   
    [mySubmission startAsynchRequest];    

    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testSubmissionStories {
    [BVSettings instance].customerName = @"stories.apitestcustomer";    
    requestComplete = NO;
    receivedProgressCallback = NO;
    BVSubmissionStory *mySubmission = [[BVSubmissionStory alloc] init];
    mySubmission.parameters.title = @"This is the title";
    mySubmission.parameters.storyText = @"This is my story";
    mySubmission.parameters.categoryId = @"1020235";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.delegate = self;
    
    [mySubmission startAsynchRequest];  

    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testSubmissionComments {
    requestComplete = NO;
    receivedProgressCallback = NO;
    BVSubmissionReviewComment *mySubmission = [[BVSubmissionReviewComment alloc] init];    
    mySubmission.parameters.commentText = @"This is my comment text";
    mySubmission.parameters.reviewId = @"83964";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.delegate = self;
    
    [mySubmission startAsynchRequest];            
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}


- (void)testSubmissionVideos {
    requestComplete = NO;
    receivedProgressCallback = NO;
    BVSubmissionVideo *mySubmission = [[BVSubmissionVideo alloc] init];    
    mySubmission.parameters.contentType = @"review";
    mySubmission.parameters.video = @"http://www.youtube.com/";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.delegate = self;

    [mySubmission startAsynchRequest];                
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}



- (void)testSubmissionPhotos {
    requestComplete = NO;
    receivedProgressCallback = NO;
    BVSubmissionPhoto *mySubmission = [[BVSubmissionPhoto alloc] init];
    mySubmission.parameters.contentType = @"review";
    mySubmission.parameters.userId = @"123";
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"bv533x533" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    mySubmission.parameters.photo = image;
    mySubmission.delegate = self;
    [mySubmission startAsynchRequest];                
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
}

- (void)testSubmissionFeedback {
    requestComplete = NO;
    receivedProgressCallback = NO;
    BVSubmissionFeedback *mySubmission = [[BVSubmissionFeedback alloc] init];
    mySubmission.parameters.contentType = @"review";
    mySubmission.parameters.contentId = @"83964";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.parameters.feedbackType = @"helpfulness";
    mySubmission.parameters.vote = @"negative";
    mySubmission.delegate = self;
    [mySubmission startAsynchRequest];                
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
}

- (void)testSubmissionFeedback2 {
    requestComplete = NO;
    receivedProgressCallback = NO;
    BVSubmissionFeedback *mySubmission = [[BVSubmissionFeedback alloc] init];
    mySubmission.parameters.contentType = @"review";
    mySubmission.parameters.contentId = @"83964";
    mySubmission.parameters.userId = @"123abc";
    mySubmission.parameters.feedbackType = @"inappropriate";
    mySubmission.parameters.reasonText = @"This post was not nice.";
    mySubmission.delegate = self;
    [mySubmission startAsynchRequest];                
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
}

- (void)testParamsAttached {
    requestComplete = NO;
    receivedProgressCallback = NO;
    BVSubmissionReview *mySubmission = [[BVSubmissionReview alloc] init];
    mySubmission.parameters.productId = @"10000sadfgasdg3401";
    mySubmission.parameters.userId = @"WHEEEEMYNAMEISSAME";
    mySubmission.parameters.rating = @"5";
    mySubmission.parameters.title = @"Test title";
    mySubmission.parameters.reviewText = @"Some kind of review text. Some kind of review text. Some kind of review text. Some kind of review text. Some kind of review text. Some kind of review text. Some kind of review text. Some kind of review text. Some kind of review text.";
    mySubmission.parameters.userNickName = @"testnickname4";
    [mySubmission.parameters.photoURL addKey:@"1" andValue:@"http://apitestcustomer.ugc.bazaarvoice.com/bvstaging/5555/ps_amazon_s3_3rgg6s4xvev0zhzbnabyneo21/photo.jpg"];
    [mySubmission.parameters.photoURL addKey:@"2" andValue:@"http://apitestcustomer.ugc.bazaarvoice.com/bvstaging/5555/ps_amazon_s3_a11b8t4wlgb914fjaiudaadvo/photo.jpg"];
    [mySubmission.parameters.photoURL addKey:@"3" andValue:@"http://apitestcustomer.ugc.bazaarvoice.com/bvstaging/5555/ps_amazon_s3_5ugnhmmq24p1q35tlygrqalz9/photo.jpg"];
    [mySubmission.parameters.tag addKey:@"Pro_1" andValue:@"fit"];
    [mySubmission.parameters.tag addKey:@"Pro_2" andValue:@"comfortable fit"];
    [mySubmission.parameters.tagid addKey:@"Pro/ProService" andValue:@"true"];
    [mySubmission.parameters.tagid addKey:@"Con/ConFitness" andValue:@"true"];

    mySubmission.delegate = self;
    [mySubmission startAsynchRequest];                                
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    // Begin a run loop terminated when the requestComplete it set to true
    while (!requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);    
    NSString *url = sentRequest.parameterURL;
    NSRange aRange = [url rangeOfString:@"PhotoUrl_1="];
    if (aRange.location ==NSNotFound) {
        NSAssert(false, @"PhotoUrl_1 was not included");
    } 
    aRange = [url rangeOfString:@"PhotoUrl_2="];
    if (aRange.location ==NSNotFound) {
        NSAssert(false, @"PhotoUrl_2 was not included");
    }
    aRange = [url rangeOfString:@"PhotoUrl_2="];
    if (aRange.location ==NSNotFound) {
        NSAssert(false, @"PhotoUrl_3 was not included");
    } 
    aRange = [url rangeOfString:@"tag_Pro_1=fit"];
    if (aRange.location ==NSNotFound) {
        NSAssert(false, @"tag_Pro_1 was not included");
    } 
    aRange = [url rangeOfString:@"tag_Pro_2=comfortable"];
    if (aRange.location ==NSNotFound) {
        NSAssert(false, @"tag_Pro_2 was not included");
    }
}
 
@end