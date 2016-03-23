//
//  BVCurationsTests.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <BVSDK/BVCurations.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>

@interface BundleLocator : NSObject
@end

@interface UIImage (Test)
+(UIImage*)testImageNamed:(NSString*) imageName;
@end

@implementation BundleLocator
@end

@implementation UIImage (Test)
+(UIImage*)testImageNamed:(NSString*) imageName
{
    NSBundle *bundle = [NSBundle bundleForClass:[BundleLocator class]];
    NSString *imagePath = [bundle pathForResource:imageName.stringByDeletingPathExtension ofType:imageName.pathExtension];
    return [UIImage imageWithContentsOfFile:imagePath];
}
@end


@interface BVCurationsTests : XCTestCase

@end

@implementation BVCurationsTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [[BVSDKManager sharedManager] setApiKeyCurations:@"fakeymcfakersonfakekey"];
    [[BVSDKManager sharedManager] setClientId:@"test-classic"];
    [[BVSDKManager sharedManager] setStaging:YES];
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelVerbose];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
     [OHHTTPStubs removeAllStubs];
    
}

// Test normal parse result from a feed
- (void)testFetchCurations {
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host containsString:@"api.bazaarvoice.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // This is our normal use case
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"curationsFeedTest1.json", self.class)
                                                                  statusCode:200
                                                                     headers:@{@"Content-Type":@"application/json"}]
                                 responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testFetchCurations"];
    
    BVCurationsFeedRequest *feedRequest = [[BVCurationsFeedRequest alloc] initWithGroups:@[ @"livebv", @"test2", @"test3" ]];
    
    // media={'video':{'width':480,'height':360}}
    feedRequest.media = @{
                          @"media" : @{
                                @"width" : @"480",
                                @"height" : @"360"
                          }
    };
    
    BVCurationsFeedLoader *urlRequest = [[BVCurationsFeedLoader alloc] init];

    [urlRequest loadFeedWithRequest:feedRequest completionHandler:^(NSArray *feedItems) {
        // success!
       
        XCTAssertNotNil(feedItems, @"ERROR: feeItems should not be nil in curations api response.");
        
        bool hasPhotos = NO;
        bool hasVideos = NO;
        for (BVCurationsFeedItem *feedItem in feedItems){
            
            if (feedItem.photos.count > 0){
                hasPhotos = YES;
            }
            if (feedItem.videos.count > 0){
                hasVideos = YES;
            }
            
        }
        
        XCTAssertTrue(hasPhotos, @"Test feed did not have photos, but should have.");
        XCTAssertTrue(hasVideos, @"Test feed did not have videos, but should have.");
        
        [expectation fulfill];
        
    } withFailure:^(NSError *error) {
        // failure : (
        
        NSString *errorString = [NSString stringWithFormat:@"ERROR: Curations API feed failure: %@", error.localizedDescription];
        XCTAssert(errorString == nil, @"%@", errorString);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations];
}

// Test proper failure of malformed JSON
- (void)testFetchCurationsMalformedJSON {
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host containsString:@"api.bazaarvoice.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // return malformed JSON object
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"curationsMalformedFeedTest1.json", self.class)
                                                 statusCode:200
                                                    headers:@{@"Content-Type":@"application/json"}]
                responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testFetchCurationsMalformedJSON"];
    
    BVCurationsFeedRequest *feedRequest = [[BVCurationsFeedRequest alloc] initWithGroups:@[ @"livebv" ]];
    
    BVCurationsFeedLoader *urlRequest = [[BVCurationsFeedLoader alloc] init];
    
    [urlRequest loadFeedWithRequest:feedRequest completionHandler:^(NSArray *feedItems) {
        
        XCTAssert(NO, @"Success completion block should not have been called here.");
        
        [expectation fulfill];
        
    } withFailure:^(NSError *error) {
        // failure : (
        
        NSString *errorString = [NSString stringWithFormat:@"ERROR: Curations API feed failure: %@", error.localizedDescription];
        XCTAssert(errorString != nil, @"Expected a non nil error string: %@", errorString);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations];
}


// Test proper failure of empty body but 200 response
- (void)testEmptyBodyFromFeedRequest {
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host containsString:@"api.bazaarvoice.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // successful response, but no body
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"", self.class)
                                                 statusCode:200
                                                    headers:@{@"Content-Type":@"application/json"}]
                responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testEmptyBodyFromFeedRequest"];
    
    BVCurationsFeedRequest *feedRequest = [[BVCurationsFeedRequest alloc] initWithGroups:@[ @"livebv" ]];
    
    BVCurationsFeedLoader *urlRequest = [[BVCurationsFeedLoader alloc] init];
    
    [urlRequest loadFeedWithRequest:feedRequest completionHandler:^(NSArray *feedItems) {
        
        XCTAssert(NO, @"Success completion block should not have been called here.");
        
        [expectation fulfill];
        
    } withFailure:^(NSError *error) {
        // failure : (
        
        NSString *errorString = [NSString stringWithFormat:@"ERROR: Curations API feed failure: %@", error.localizedDescription];
        XCTAssert(errorString != nil, @"Expected a non nil error string: %@", errorString);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations];
}


// HTTP status 500
- (void)testServerError500 {
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host containsString:@"api.bazaarvoice.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // successful response, but no body
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"", self.class)
                                                 statusCode:500
                                                    headers:@{@"Content-Type":@"application/json"}]
                responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testEmptyBodyFromFeedRequest"];
    
    BVCurationsFeedRequest *feedRequest = [[BVCurationsFeedRequest alloc] initWithGroups:@[ @"livebv" ]];
    
    BVCurationsFeedLoader *urlRequest = [[BVCurationsFeedLoader alloc] init];
    
    [urlRequest loadFeedWithRequest:feedRequest completionHandler:^(NSArray *feedItems) {
        
        XCTAssert(NO, @"Success completion block should not have been called here.");
        
        [expectation fulfill];
        
    } withFailure:^(NSError *error) {
        // failure : (
        
        NSString *errorString = [NSString stringWithFormat:@"ERROR: Curations API feed failure: %@", error.localizedDescription];
        XCTAssert(errorString != nil, @"Expected a non nil error string: %@", errorString);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations];
}


// Test proper failure of empty body but 200 response
- (void)testNon200Status {
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host containsString:@"api.bazaarvoice.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // successful HTTP code, but error in body
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"curations500Error.json", self.class)
                                                 statusCode:200
                                                    headers:@{
                                                              @"Content-Type":@"application/json;charset=utf-8",
                                                              @"Access-Control-Allow-Origin" : @"*",
                                                              @"Connection" : @"keep-alive",
                                                              @"Date" : @"Wed, 30 Mar 2016 15:52:51 GMT",
                                                              @"Server" : @"nginx/1.6.2",
                                                              @"Vary" : @"Accept-Encoding",
                                                              @"X-Mashery-Responder" : @"prod-j-worker-bv-us-west-1c-06.mashery.com"
                                                              }]
                responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testNon200Status"];
    
    BVCurationsFeedRequest *feedRequest = [[BVCurationsFeedRequest alloc] initWithGroups:@[ @"livebv" ]];
    
    BVCurationsFeedLoader *urlRequest = [[BVCurationsFeedLoader alloc] init];
    
    [urlRequest loadFeedWithRequest:feedRequest completionHandler:^(NSArray *feedItems) {
        
        XCTAssert(NO, @"Success completion block should not have been called here.");
        
        [expectation fulfill];
        
    } withFailure:^(NSError *error) {
        // failure : (
        
        NSString *errorString = [NSString stringWithFormat:@"ERROR: Curations API feed failure: %@", error.localizedDescription];
        XCTAssert(errorString != nil, @"Expected a non nil error string: %@", errorString);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations];
}

// Test setting all the display api query string input and that we can fetch them out parameterized as NSURLQueryItem objects.
- (void)testCurationsFeedQueryStringParams {
    
    NSDictionary *expectedResults = @{
                                      @"passkey" : @"fakeymcfakersonfakekey",
                                      @"client" : @"test-classic",
                                      @"limit" : @"33",
                                      @"groups" : @"group-1",
                                      @"tags" : @"tag2",
                                      @"before" : @"1451606400",
                                      @"after" : @"1325376000",
                                      @"author" : @"testAuthor",
                                      @"featured" : @"3",
                                      @"has_geotag" : @"true",
                                      @"has_photo" : @"true",
                                      @"has_link" : @"true",
                                      @"has_video" : @"true",
                                      @"withProductData" : @"true",
                                      @"include_comments" : @"true",
                                      @"per_group_limit" : @"5",
                                      @"externalId" : @"123abdDEF",
                                      @"explicit_permission" : @"true",
                                      @"media" : @"{\"video\":{\"width\":\"480\",\"height\":\"360\"}}"
                                      };
    
    
    BVCurationsFeedRequest *feedRequest = [[BVCurationsFeedRequest alloc] initWithGroups:@[ @"group-1"]];
    
    feedRequest.limit = 33;
    feedRequest.tags = @[ @"tag2"];
    
    // media={'video':{'width':480,'height':360}}
    feedRequest.media = @{
          @"video" : @{
                  @"width" : @"480",
                  @"height" : @"360"
                  }
          };
    
    feedRequest.author = @"testAuthor";
    feedRequest.externalId = @"123abdDEF";
    
    feedRequest.featured =  3;
    feedRequest.perGroupLimit = 5;
    
    feedRequest.hasGeotag = YES;
    feedRequest.hasLink = YES;
    feedRequest.hasVideo = YES;
    feedRequest.hasPhoto = YES;
    feedRequest.includeComments = YES;
    feedRequest.explicitPermission = YES;
    feedRequest.withProductData = YES;
    
    feedRequest.before = [NSNumber numberWithLong:1451606400]; // Fri, 01 Jan 2016 00:00:00 GMT
    feedRequest.after = [NSNumber numberWithLong:1325376000];  // Sun, 01 Jan 2012 00:00:00 GMT

    NSArray *queryParams = [feedRequest createQueryItems];
    
    XCTAssertTrue([queryParams count] == [[expectedResults allKeys] count], @"Number of query items is not equal to the expected results dictionary");
    
    for (NSURLQueryItem *qi in queryParams){
        
        NSString *name = qi.name;
        NSString *value = qi.value;
        
        NSString *expectedString = [expectedResults objectForKey:name];
        
        XCTAssertTrue([expectedString isEqualToString:value], @"ERROR: Query string value %@ for name %@ is not equal to expected value %@", value, name, expectedString);
        
    }
    
}

// Test for serialization/de-serialization of the API parameters for BVCurationsAddPostParams
- (void)testPostParamsOnly {
    
    // Test inputs - required
    NSString *aliasInput = @"aliasText";
    NSString *tokenInput = @"tokenText";
    NSString *textInput = @"test text: barrells of monkeys u haz";
    NSArray *groupsInput = @[@"group1-one", @"group2-two", @"group3-three"];
    
    // Test input - optionals
    
    NSString *proifleURLInput = @"http://profileurltest";
    NSString *avatarURLInput = @"http://avatarurl";
//    double longInput = 21.98765;
//    double latInput = 0.12345;
    
    NSArray *tagsInput = @[@"tag1", @"tag2"];
    NSString *permalinkInput = @"http://permalinktest";
    NSString *placeInput = @"Austin, TX";
    NSString *teaserInput = @"Testing «ταБЬℓσ»: 1<2 & 4+1>3, now 20% off!";
    
    NSTimeInterval timeStampInput = [[NSDate date] timeIntervalSince1970];
    
    NSArray *linksInput = @[@"http://www.bazaarvoice.com/", @"http://acl-live.com/"];
    NSArray *photosInput = @[@"http://homeopathyplus.com/wp-content/uploads/2013/01/MotherTeresa-223x300.png", @"https://upload.wikimedia.org/wikipedia/commons/6/6f/Einstein-formal_portrait-35.jpg"];

    BVCurationsAddPostRequest *params = [[BVCurationsAddPostRequest alloc] initWithGroups:groupsInput withAuthorAlias:aliasInput withToken:tokenInput withText:textInput withImage:[UIImage testImageNamed:@"test_pattern.jpg"]];
    
//    params.latitude = latInput;
//    params.longitude = longInput;
    
    params.authorProfileURL = proifleURLInput;
    params.authorAvatarURL = avatarURLInput;
    
    params.tags = tagsInput;
    params.permalink = permalinkInput;
    params.place = placeInput;
    params.teaser = teaserInput;
    params.unixTimeStamp = timeStampInput;
    
    params.links = linksInput;
    params.photos = photosInput;
    
    NSData *jsonData = params.serializeParameters;
    
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];

    if (error || jsonDict == nil){
        // fail
        XCTAssertTrue(NO, @"An error occurred deserializing the parameters.");
    }
    
    NSLog(@"%@", jsonDict);
    
    NSString *aliasTest=    [[jsonDict objectForKey:@"author"] objectForKey:@"alias"];
    NSString *tokenTest =   [[jsonDict objectForKey:@"author"] objectForKey:@"token"];
    NSString *textTest =    [jsonDict objectForKey:@"text"];
    NSArray *groupsTest =    [jsonDict objectForKey:@"groups"];
    NSArray *tagsTest =    [jsonDict objectForKey:@"tags"];
    
    NSString *authorProfileURLTest = [[jsonDict objectForKey:@"author"] objectForKey:@"profile"];
    NSString *avatarURLTest =   [[jsonDict objectForKey:@"author"] objectForKey:@"avatar"];
    
    NSString *permaLinkTest = [jsonDict objectForKey:@"permalink"];
    NSString *placeTest = [jsonDict objectForKey:@"place"];
    NSString *teaserTest = [jsonDict objectForKey:@"teaser"];
    NSTimeInterval timeStampTest = [[jsonDict objectForKey:@"timestamp"] doubleValue];
    
    NSArray *linksTest = [jsonDict objectForKey:@"links"];
    NSArray *photosTest = [jsonDict objectForKey:@"photos"];
    
//    double latitudeTest = [[[jsonDict objectForKey:@"coordinates"] objectForKey:@"latitude"] doubleValue];
//    double longitudeTest = [[[jsonDict objectForKey:@"coordinates"] objectForKey:@"longitude"] doubleValue];

    
    // Test validation
    XCTAssertTrue([aliasInput isEqualToString:aliasTest], @"Equivalency test failed.");
    XCTAssertTrue([tokenInput isEqualToString:tokenTest], @"Equivalency test failed.");
    XCTAssertTrue([textInput isEqualToString:textTest], @"Equivalency test failed.");
    XCTAssertTrue([groupsInput isEqualToArray:groupsTest], @"Equivalency test failed.");
   
    XCTAssertTrue([proifleURLInput isEqualToString:authorProfileURLTest], @"Equivalency test failed.");
    XCTAssertTrue([avatarURLInput isEqualToString:avatarURLTest], @"Equivalency test failed.");
    XCTAssertTrue([tagsInput isEqualToArray:tagsTest], @"Equivalency test failed.");
    XCTAssertTrue([permalinkInput isEqualToString:permaLinkTest], @"Equivalency test failed.");
    XCTAssertTrue([placeInput isEqualToString:placeTest], @"Equivalency test failed.");
    XCTAssertTrue([teaserInput isEqualToString:teaserTest], @"Equivalency test failed.");
    
    XCTAssertEqual([linksTest count], 2, @"Links count was incorrect.");
    XCTAssertEqual([photosTest count], 2, @"Photos count was incorrect.");
    
    double inputRounded = floorf(timeStampInput);
    double testCaseRounded = floorf(timeStampTest);
    
    XCTAssertEqual(inputRounded, testCaseRounded, @"Equivalency test failed.");
//    XCTAssertEqual(latInput, latitudeTest, @"Latitude test failed.");
//    XCTAssertEqual(longInput, longitudeTest, @"Longitude test failed.");

    XCTAssertNotNil(params.image, @"Image should not have been nil");
    
}

- (void)testPostPhotoSuccess {
    
     __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testPostPhotoSuccess"];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host containsString:@"api.bazaarvoice.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // successful response, but no body
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"post_successfulCreation.json", self.class)
                                                 statusCode:201
                                                    headers:@{@"Content-Type":@"application/json"}]
                responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
    

    // Construct the parmas with required
    NSString *aliasInput = @"mobileUnitTest";
    NSString *tokenInput = @"mobilecoreteam@bazaarvoice.com";
    NSString *textInput = @"Testing «ταБЬℓσ»: 1<2 & 4+1>3, now 20% off!";
    NSArray *groupsInput = @[@"pie-test"];
    NSArray *tags = @[@"submission-app", @"product1", @"sampleCategory"];
    
    UIImage *testImage = [UIImage testImageNamed:@"test_pattern.jpg"];
    
    BVCurationsAddPostRequest *params = [[BVCurationsAddPostRequest alloc] initWithGroups:groupsInput withAuthorAlias:aliasInput withToken:tokenInput withText:textInput];
    
    params.image = testImage;
    params.tags = tags;
    
    // Hit the API
    BVCurationsPhotoUploader *uploadAPI = [[BVCurationsPhotoUploader alloc] init];
    
    [uploadAPI submitCurationsContentWithParams:params completionHandler:^(void) {
        // completion
        NSLog(@"Successful Test!");
        
        // TODO: Assert if data is nil
        
        [expectation fulfill];
    } withFailure:^(NSError *error) {
        // error
        NSLog(@"ERROR: %@", error.localizedDescription);
        XCTAssertTrue(NO, @"Error block called in test should not have been called.");
        [expectation fulfill];
    }];
    
    [self waitForExpectations];
    
}



- (void)testPostPhotoFail {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testPostPhotoFail"];
    
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.host containsString:@"api.bazaarvoice.com"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            // successful response, but no body
            return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"post_ErrorParsingBody.json", self.class)
                                                     statusCode:200
                                                        headers:@{@"Content-Type":@"application/json"}]
                    responseTime:OHHTTPStubsDownloadSpeedWifi];
        }];
    
    
    // Construct the parmas with required
    NSString *aliasInput = @"mobileUnitTest";
    NSString *tokenInput = @"mobilecoreteam@bazaarvoice.com";
    NSString *textInput = @"Testing «ταБЬℓσ»: 1<2 & 4+1>3, now 20% off!";
    NSArray *groupsInput = @[@"pie-test"];
    NSArray *tags = @[@"submission-app", @"product1", @"sampleCategory"];
    
    UIImage *testImage = [UIImage testImageNamed:@"test_pattern.jpg"];
    
    BVCurationsAddPostRequest *params = [[BVCurationsAddPostRequest alloc] initWithGroups:groupsInput withAuthorAlias:aliasInput withToken:tokenInput withText:textInput];
    
    params.image = testImage;
    params.tags = tags;
    
    // Hit the API
    BVCurationsPhotoUploader *uploadAPI = [[BVCurationsPhotoUploader alloc] init];
    
    [uploadAPI submitCurationsContentWithParams:params completionHandler:^(void) {
        // completion
        NSLog(@"success");
        XCTAssertTrue(NO, @"Success block called in test which should have failed.");
        [expectation fulfill];
    } withFailure:^(NSError *error) {
        // error
        NSLog(@"ERROR: %@", error.localizedDescription);
        
        XCTAssertNotNil(error, @"Got a nil NSError object");
        XCTAssertEqual(error.code, 500, @"Expected error code 500");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations];
    
}


- (void)testPostMissingRequiredKey {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testPostMissingRequiredKey"];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host containsString:@"api.bazaarvoice.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // successful response, but no body
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"post_MissingRequiredKey.json", self.class)
                                                 statusCode:200
                                                    headers:@{@"Content-Type":@"application/json"}]
                responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
    
    
    // Construct the parmas with required
    NSString *aliasInput = @"";
    NSString *tokenInput = @"";
    NSString *textInput = @"";
    NSArray *groupsInput = @[];
    
    BVCurationsAddPostRequest *params = [[BVCurationsAddPostRequest alloc] initWithGroups:groupsInput withAuthorAlias:aliasInput withToken:tokenInput withText:textInput];
    
    // Hit the API
    BVCurationsPhotoUploader *uploadAPI = [[BVCurationsPhotoUploader alloc] init];
    
    [uploadAPI submitCurationsContentWithParams:params completionHandler:^(void) {
        // completion
        NSLog(@"success");
        XCTAssertTrue(NO, @"Success block called in test which should have failed.");
        [expectation fulfill];
    } withFailure:^(NSError *error) {
        // error
        NSLog(@"ERROR: %@", error.localizedDescription);
        XCTAssertNotNil(error, @"Got a nil NSError object");
        XCTAssertEqual(error.code, 400, @"Expected error code 400");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations];
    
}


- (void)testPostMalformedJSONResponse {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testPostMalformedJSONResponse"];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host containsString:@"api.bazaarvoice.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // successful response, but no body
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"curationsMalformedFeedTest1.json", self.class)
                                                 statusCode:200
                                                    headers:@{@"Content-Type":@"application/json"}]
                responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
    
    
    // Construct the parmas with required
    NSString *aliasInput = @"";
    NSString *tokenInput = @"";
    NSString *textInput = @"";
    NSArray *groupsInput = @[];
    
    BVCurationsAddPostRequest *params = [[BVCurationsAddPostRequest alloc] initWithGroups:groupsInput withAuthorAlias:aliasInput withToken:tokenInput withText:textInput];
    
    // Hit the API
    BVCurationsPhotoUploader *uploadAPI = [[BVCurationsPhotoUploader alloc] init];
    
    [uploadAPI submitCurationsContentWithParams:params completionHandler:^(void) {
        // completion
        NSLog(@"success");
        XCTAssertTrue(NO, @"Success block called in test which should have failed.");
        [expectation fulfill];
    } withFailure:^(NSError *error) {
        // error
        NSLog(@"ERROR: %@", error.localizedDescription);
        XCTAssertNotNil(error, @"Got a nil NSError object");
        XCTAssertEqual(error.code, -1, @"Expected error code -1");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations];
    
}


- (void)testPostNilRequestObject {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testPostNilRequestObject"];
    
    
    // Hit the API - which should never make an API call and just return the error handler
    BVCurationsPhotoUploader *uploadAPI = [[BVCurationsPhotoUploader alloc] init];
    
    [uploadAPI submitCurationsContentWithParams:nil completionHandler:^(void) {
        // completion
        NSLog(@"success");
        XCTAssertTrue(NO, @"Success block called in test which should have failed.");
        [expectation fulfill];
    } withFailure:^(NSError *error) {
        // error
        NSLog(@"ERROR: %@", error.localizedDescription);
        XCTAssertNotNil(error, @"Got a nil NSError object");
        XCTAssertEqual(error.code, -1, @"Expected error code -1");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations];
    
}


- (void) waitForExpectations{
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
}


@end


