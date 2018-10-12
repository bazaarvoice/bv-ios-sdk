//
//  BVCurationsTests.m
//  BVSDKTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBaseStubTestCase.h"
#import "BVNetworkDelegateTestsDelegate.h"
#import <BVSDK/BVCurations.h>
#import <XCTest/XCTest.h>

@interface BVCurationsTests : BVBaseStubTestCase
@end

@implementation BVCurationsTests

- (void)setUp {
  [super setUp];

  // Put setup code here. This method is called before the invocation of each
  // test method in the class.
  NSDictionary *configDict = @{
    @"apiKeyCurations" : @"fakeymcfakersonfakekey",
    @"clientId" : @"test-classic"
  };
  [BVSDKManager configureWithConfiguration:configDict
                                configType:BVConfigurationTypeStaging];
  [[BVSDKManager sharedManager] setLogLevel:BVLogLevelError];
  [BVSDKManager sharedManager].urlSessionDelegate = nil;
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of
  // each
  // test method in the class.
  [super tearDown];
}

// Load image by name for the test bundle
- (UIImage *)loadTestImageNamed:(NSString *)imageName {
  return [UIImage imageNamed:imageName
                           inBundle:[NSBundle
                                        bundleForClass:[BVCurationsTests class]]
      compatibleWithTraitCollection:nil];
}

// Test normal parse result from a feed
- (void)testFetchCurations {
  [self forceStubWithJSON:@"curationsFeedTest1.json"];

  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testFetchCurations"];

  BVCurationsFeedRequest *feedRequest = [[BVCurationsFeedRequest alloc]
      initWithGroups:@[ @"livebv", @"test2", @"test3" ]];

  // media={'video':{'width':480,'height':360}}
  feedRequest.media = @{ @"media" : @{@"width" : @"480", @"height" : @"360"} };

  BVCurationsFeedLoader *urlRequest = [[BVCurationsFeedLoader alloc] init];

  [urlRequest loadFeedWithRequest:feedRequest
      completionHandler:^(NSArray *feedItems) {
        // success!

        XCTAssertNotNil(
            feedItems,
            @"ERROR: feeItems should not be nil in curations api response.");

        bool hasPhotos = NO;
        bool hasVideos = NO;
        for (BVCurationsFeedItem *feedItem in feedItems) {
          if (feedItem.photos.count > 0) {
            hasPhotos = YES;
          }
          if (feedItem.videos.count > 0) {
            hasVideos = YES;
          }
        }

        XCTAssertTrue(hasPhotos,
                      @"Test feed did not have photos, but should have.");
        XCTAssertTrue(hasVideos,
                      @"Test feed did not have videos, but should have.");

        [expectation fulfill];

      }
      withFailure:^(NSError *error) {
        // failure : (

        NSString *errorString =
            [NSString stringWithFormat:@"ERROR: Curations API feed failure: %@",
                                       error.localizedDescription];
        XCTAssertNil(errorString, @"%@", errorString);

        [expectation fulfill];
      }];

  [self waitForExpectations];
}

// Test normal parse result from a feed but using network delegate
- (void)testFetchCurationsWithNetworkDelegate {
  [self forceStubWithJSON:@"curationsFeedTest1.json"];

  __weak XCTestExpectation *mainExpectation = [self
      expectationWithDescription:@"testFetchCurationsWithNetworkDelegate"];

  BVCurationsFeedRequest *feedRequest = [[BVCurationsFeedRequest alloc]
      initWithGroups:@[ @"livebv", @"test2", @"test3" ]];

  // media={'video':{'width':480,'height':360}}
  feedRequest.media = @{ @"media" : @{@"width" : @"480", @"height" : @"360"} };

  BVCurationsFeedLoader *urlRequest = [[BVCurationsFeedLoader alloc] init];

  /// Setup the networking test delegate
  BVNetworkDelegateTestsDelegate *testDelegate =
      [[BVNetworkDelegateTestsDelegate alloc] init];
  XCTAssertNotNil(testDelegate, @"BVNetworkDelegateTestsDelegate is nil.");

  testDelegate.urlSessionExpectation =
      [self expectationWithDescription:
                @"testFetchCurationsWithNetworkDelegate urlSessionExpectation"];

  testDelegate.urlSessionTaskExpectation =
      [self expectationWithDescription:
                @"testFetchCurationsWithNetworkDelegate urlSessionExpectation"];

  [BVSDKManager sharedManager].urlSessionDelegate = testDelegate;

  [urlRequest loadFeedWithRequest:feedRequest
      completionHandler:^(NSArray *feedItems) {
        // success!

        XCTAssertNotNil(
            feedItems,
            @"ERROR: feeItems should not be nil in curations api response.");

        bool hasPhotos = NO;
        bool hasVideos = NO;
        for (BVCurationsFeedItem *feedItem in feedItems) {
          if (feedItem.photos.count > 0) {
            hasPhotos = YES;
          }
          if (feedItem.videos.count > 0) {
            hasVideos = YES;
          }
        }

        XCTAssertTrue(hasPhotos,
                      @"Test feed did not have photos, but should have.");
        XCTAssertTrue(hasVideos,
                      @"Test feed did not have videos, but should have.");

        [mainExpectation fulfill];

      }
      withFailure:^(NSError *error) {
        // failure : (

        NSString *errorString =
            [NSString stringWithFormat:@"ERROR: Curations API feed failure: %@",
                                       error.localizedDescription];
        XCTAssertNil(errorString, @"%@", errorString);

        [mainExpectation fulfill];
      }];

  [self waitForExpectations];
}

// Test fetching curations with user's geolocation
- (void)testFetchCurationsWithLocation {
  [self forceStubWithJSON:@"curationsFeedTest1.json"];

  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testFetchCurationsWithLocation"];

  BVCurationsFeedRequest *feedRequest =
      [[BVCurationsFeedRequest alloc] initWithGroups:@[ @"__all__" ]];
  [feedRequest setLatitude:30.2 longitude:-97.7];

  BVCurationsFeedLoader *urlRequest = [[BVCurationsFeedLoader alloc] init];

  [urlRequest loadFeedWithRequest:feedRequest
      completionHandler:^(NSArray *feedItems) {
        // success!

        XCTAssertNotNil(
            feedItems,
            @"ERROR: feeItems should not be nil in curations api response.");

        NSInteger locationCount = 0;
        for (BVCurationsFeedItem *feedItem in feedItems) {
          if (feedItem.coordinates && feedItem.coordinates.latitude &&
              feedItem.coordinates.longitude) {
            locationCount += 1;
          }
        }

        XCTAssertEqual(21, locationCount,
                       @"There should be 11 feed items "
                       @"with coordinates attached to "
                       @"them");
        XCTAssertEqual(40, [feedItems count],
                       @"There should be 20 total feed items");

        [expectation fulfill];

      }
      withFailure:^(NSError *error) {
        // failure : (

        NSString *errorString =
            [NSString stringWithFormat:@"ERROR: Curations API feed failure: %@",
                                       error.localizedDescription];
        XCTAssertNil(errorString, @"%@", errorString);

        [expectation fulfill];
      }];

  [self waitForExpectations];
}

// Test proper failure of malformed JSON
- (void)testFetchCurationsMalformedJSON {
  [self stubWithJSON:@"malformedJSON.json"];

  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testFetchCurationsMalformedJSON"];

  BVCurationsFeedRequest *feedRequest =
      [[BVCurationsFeedRequest alloc] initWithGroups:@[ @"livebv" ]];

  BVCurationsFeedLoader *urlRequest = [[BVCurationsFeedLoader alloc] init];

  [urlRequest loadFeedWithRequest:feedRequest
      completionHandler:^(NSArray *feedItems) {

        XCTAssert(
            NO, @"Success completion block should not have been called here.");

        [expectation fulfill];

      }
      withFailure:^(NSError *error) {
        // failure : (

        NSString *errorString =
            [NSString stringWithFormat:@"ERROR: Curations API feed failure: %@",
                                       error.localizedDescription];
        XCTAssertNotNil(errorString, @"Expected a non nil error string: %@",
                        errorString);

        [expectation fulfill];
      }];

  [self waitForExpectations];
}

// Test proper failure of empty body but 200 response
- (void)testEmptyBodyFromFeedRequest {
  [self stubWithJSON:@""];

  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testEmptyBodyFromFeedRequest"];

  BVCurationsFeedRequest *feedRequest =
      [[BVCurationsFeedRequest alloc] initWithGroups:@[ @"livebv" ]];

  BVCurationsFeedLoader *urlRequest = [[BVCurationsFeedLoader alloc] init];

  [urlRequest loadFeedWithRequest:feedRequest
      completionHandler:^(NSArray *feedItems) {

        XCTAssert(
            NO, @"Success completion block should not have been called here.");

        [expectation fulfill];

      }
      withFailure:^(NSError *error) {
        // failure : (

        NSString *errorString =
            [NSString stringWithFormat:@"ERROR: Curations API feed failure: %@",
                                       error.localizedDescription];
        XCTAssertNotNil(errorString, @"Expected a non nil error string: %@",
                        errorString);

        [expectation fulfill];
      }];

  [self waitForExpectations];
}

// HTTP status 500
- (void)testServerError500 {
  [self stubWithResultFile:@""
                statusCode:500
               withHeaders:@{@"Content-Type" : @"application/json"}];

  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testEmptyBodyFromFeedRequest"];

  BVCurationsFeedRequest *feedRequest =
      [[BVCurationsFeedRequest alloc] initWithGroups:@[ @"livebv" ]];

  BVCurationsFeedLoader *urlRequest = [[BVCurationsFeedLoader alloc] init];

  [urlRequest loadFeedWithRequest:feedRequest
      completionHandler:^(NSArray *feedItems) {

        XCTAssert(
            NO, @"Success completion block should not have been called here.");

        [expectation fulfill];

      }
      withFailure:^(NSError *error) {
        // failure : (

        NSString *errorString =
            [NSString stringWithFormat:@"ERROR: Curations API feed failure: %@",
                                       error.localizedDescription];
        XCTAssertNotNil(errorString, @"Expected a non nil error string: %@",
                        errorString);

        [expectation fulfill];
      }];

  [self waitForExpectations];
}

// Test proper failure of empty body but 200 response
- (void)testNon200Status {
  [self stubWithResultFile:@"curations500Error.json"
                statusCode:200
               withHeaders:@{
                 @"Content-Type" : @"application/json;charset=utf-8",
                 @"Access-Control-Allow-Origin" : @"*",
                 @"Connection" : @"keep-alive",
                 @"Date" : @"Wed, 30 Mar 2016 15:52:51 GMT",
                 @"Server" : @"nginx/1.6.2",
                 @"Vary" : @"Accept-Encoding",
                 @"X-Mashery-Responder" :
                     @"prod-j-worker-bv-us-west-1c-06.mashery.com"
               }];

  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testNon200Status"];

  BVCurationsFeedRequest *feedRequest =
      [[BVCurationsFeedRequest alloc] initWithGroups:@[ @"livebv" ]];

  BVCurationsFeedLoader *urlRequest = [[BVCurationsFeedLoader alloc] init];

  [urlRequest loadFeedWithRequest:feedRequest
      completionHandler:^(NSArray *feedItems) {

        XCTAssert(
            NO, @"Success completion block should not have been called here.");

        [expectation fulfill];

      }
      withFailure:^(NSError *error) {
        // failure : (

        NSString *errorString =
            [NSString stringWithFormat:@"ERROR: Curations API feed failure: %@",
                                       error.localizedDescription];
        XCTAssertNotNil(errorString, @"Expected a non nil error string: %@",
                        errorString);

        [expectation fulfill];
      }];

  [self waitForExpectations];
}

// Test setting all the display api query string input and that we can fetch
// them out parameterized as NSURLQueryItem objects.
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
    @"externalId" : @"123abdDEF",
    @"media" : @"{\"video\":{\"width\":\"480\",\"height\":\"360\"}}"
  };

  BVCurationsFeedRequest *feedRequest =
      [[BVCurationsFeedRequest alloc] initWithGroups:@[ @"group-1" ]];

  feedRequest.limit = 33;
  feedRequest.tags = @[ @"tag2" ];

  // media={'video':{'width':480,'height':360}}
  feedRequest.media = @{ @"video" : @{@"width" : @"480", @"height" : @"360"} };

  feedRequest.author = @"testAuthor";
  feedRequest.externalId = @"123abdDEF";

  feedRequest.featured = 3;

  feedRequest.hasGeotag = @YES;
  feedRequest.hasLink = @YES;
  feedRequest.hasVideo = @YES;
  feedRequest.hasPhoto = @YES;
  feedRequest.includeComments = @YES;
  feedRequest.withProductData = @YES;

  feedRequest.before =
      [NSNumber numberWithLong:1451606400]; // Fri, 01 Jan 2016 00:00:00 GMT
  feedRequest.after =
      [NSNumber numberWithLong:1325376000]; // Sun, 01 Jan 2012 00:00:00 GMT

  NSArray *queryParams = [feedRequest createQueryItems];

  XCTAssertTrue([queryParams count] == [[expectedResults allKeys] count],
                @"Number of query items is not equal to the expected results "
                @"dictionary");

  for (NSURLQueryItem *qi in queryParams) {
    NSString *name = qi.name;
    NSString *value = qi.value;

    NSString *expectedString = [expectedResults objectForKey:name];

    XCTAssertTrue([expectedString isEqualToString:value],
                  @"ERROR: Query string value %@ for name %@ is not equal to "
                  @"expected value %@",
                  value, name, expectedString);
  }
}

- (void)waitForExpectations {
  [self waitForExpectationsWithTimeout:30.0
                               handler:^(NSError *error) {

                                 if (error) {
                                   XCTFail(@"Expectation Failed with error: %@",
                                           error);
                                 }

                               }];
}

/*
// Test for serialization/de-serialization of the API parameters for
// BVCurationsAddPostParams
- (void)testPostParamsOnly {
  // Test inputs - required
  NSString *aliasInput = @"aliasText";
  NSString *tokenInput = @"tokenText";
  NSString *textInput = @"test text: barrells of monkeys u haz";
  NSArray *groupsInput = @[ @"group1-one", @"group2-two", @"group3-three" ];

  // Test input - optionals

  NSString *proifleURLInput = @"http://profileurltest";
  NSString *avatarURLInput = @"http://avatarurl";
  double longInput = 21.98765;
  double latInput = 0.12345;

  NSArray *tagsInput = @[ @"tag1", @"tag2" ];
  NSString *permalinkInput = @"http://permalinktest";
  NSString *placeInput = @"Austin, TX";
  NSString *teaserInput = @"Testing «ταБЬℓσ»: 1<2 & 4+1>3, now 20% off!";

  NSTimeInterval timeStampInput = [[NSDate date] timeIntervalSince1970];

  NSArray *linksInput =
      @[ @"http://www.bazaarvoice.com/", @"http://acl-live.com/" ];

  // To eliminate the NSString literal warning within NSArray convenience
  // initializer.
  NSString *photosUrl1 = [NSString
      stringWithFormat:@"%@", @"http://homeopathyplus.com/wp-content/uploads/"
                              @"2013/01/MotherTeresa-223x300.png"];

  NSString *photosUrl2 =
      [NSString stringWithFormat:@"%@", @"https://upload.wikimedia.org/"
                                        @"wikipedia/commons/6/6f/"
                                        @"Einstein-formal_portrait-35.jpg"];

  NSArray *photosInput = @[ photosUrl1, photosUrl2 ];

  UIImage *testImage = [self loadTestImageNamed:@"test_pattern.jpg"];

  BVCurationsAddPostRequest *params =
      [[BVCurationsAddPostRequest alloc] initWithGroups:groupsInput
                                        withAuthorAlias:aliasInput
                                              withToken:tokenInput
                                               withText:textInput
                                              withImage:testImage];

  params.latitude = latInput;
  params.longitude = longInput;

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
  NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                           options:kNilOptions
                                                             error:&error];

  if (error || jsonDict ) {
    // fail
    XCTAssertTrue(NO, @"An error occurred deserializing the parameters.");
  }

  NSLog(@"%@", jsonDict);

  NSString *aliasTest =
      [[jsonDict objectForKey:@"author"] objectForKey:@"alias"];
  NSString *tokenTest =
      [[jsonDict objectForKey:@"author"] objectForKey:@"token"];
  NSString *textTest = [jsonDict objectForKey:@"text"];
  NSArray *groupsTest = [jsonDict objectForKey:@"groups"];
  NSArray *tagsTest = [jsonDict objectForKey:@"tags"];

  NSString *authorProfileURLTest =
      [[jsonDict objectForKey:@"author"] objectForKey:@"profile"];
  NSString *avatarURLTest =
      [[jsonDict objectForKey:@"author"] objectForKey:@"avatar"];

  NSString *permaLinkTest = [jsonDict objectForKey:@"permalink"];
  NSString *placeTest = [jsonDict objectForKey:@"place"];
  NSString *teaserTest = [jsonDict objectForKey:@"teaser"];
  NSTimeInterval timeStampTest =
      [[jsonDict objectForKey:@"timestamp"] doubleValue];

  NSArray *linksTest = [jsonDict objectForKey:@"links"];
  NSArray *photosTest = [jsonDict objectForKey:@"photos"];

  double latitudeTest =
      [[[jsonDict objectForKey:@"coordinates"] objectForKey:@"x"] doubleValue];
  double longitudeTest =
      [[[jsonDict objectForKey:@"coordinates"] objectForKey:@"y"] doubleValue];

  // Test validation
  XCTAssertTrue([aliasInput isEqualToString:aliasTest],
                @"Equivalency test failed.");
  XCTAssertTrue([tokenInput isEqualToString:tokenTest],
                @"Equivalency test failed.");
  XCTAssertTrue([textInput isEqualToString:textTest],
                @"Equivalency test failed.");
  XCTAssertTrue([groupsInput isEqualToArray:groupsTest],
                @"Equivalency test failed.");

  XCTAssertTrue([proifleURLInput isEqualToString:authorProfileURLTest],
                @"Equivalency test failed.");
  XCTAssertTrue([avatarURLInput isEqualToString:avatarURLTest],
                @"Equivalency test failed.");
  XCTAssertTrue([tagsInput isEqualToArray:tagsTest],
                @"Equivalency test failed.");
  XCTAssertTrue([permalinkInput isEqualToString:permaLinkTest],
                @"Equivalency test failed.");
  XCTAssertTrue([placeInput isEqualToString:placeTest],
                @"Equivalency test failed.");
  XCTAssertTrue([teaserInput isEqualToString:teaserTest],
                @"Equivalency test failed.");

  XCTAssertEqual([linksTest count], 2, @"Links count was incorrect.");
  XCTAssertEqual([photosTest count], 2, @"Photos count was incorrect.");

  double inputRounded = floorf(timeStampInput);
  double testCaseRounded = floorf(timeStampTest);

  XCTAssertEqual(inputRounded, testCaseRounded, @"Equivalency test failed.");
  XCTAssertEqual(latInput, latitudeTest, @"Latitude test failed.");
  XCTAssertEqual(longInput, longitudeTest, @"Longitude test failed.");

  XCTAssertNotNil(params.image, @"Image should not have been nil");
}

- (void)testPostPhotoSuccess {
  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testPostPhotoSuccess"];

  [self stubWithJSON:@"post_successfulCreation.json"];

  // Construct the parmas with required
  NSString *aliasInput = @"mobileUnitTest";
  NSString *tokenInput = @"mobilecoreteam@bazaarvoice.com";
  NSString *textInput = @"Testing «ταБЬℓσ»: 1<2 & 4+1>3, now 20% off!";
  NSArray *groupsInput = @[ @"pie-test" ];
  NSArray *tags = @[ @"submission-app", @"product1", @"sampleCategory" ];

  UIImage *testImage = [self loadTestImageNamed:@"test_pattern.jpg"];

  BVCurationsAddPostRequest *params =
      [[BVCurationsAddPostRequest alloc] initWithGroups:groupsInput
                                        withAuthorAlias:aliasInput
                                              withToken:tokenInput
                                               withText:textInput];

  params.image = testImage;
  params.tags = tags;

  // Hit the API
  BVCurationsPhotoUploader *uploadAPI = [[BVCurationsPhotoUploader alloc] init];

  [uploadAPI submitCurationsContentWithParams:params
      completionHandler:^(void) {
        // completion
        [expectation fulfill];
      }
      withFailure:^(NSError *error) {
        // error
        NSLog(@"ERROR: %@", error.localizedDescription);
        XCTAssertTrue(
            NO, @"Error block called in test should not have been called.");
        [expectation fulfill];
      }];

  [self waitForExpectations];
}

- (void)testPostPhotoFail {
  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testPostPhotoFail"];

  [self stubWithJSON:@"post_ErrorParsingBody.json"];

  // Construct the parmas with required
  NSString *aliasInput = @"mobileUnitTest";
  NSString *tokenInput = @"mobilecoreteam@bazaarvoice.com";
  NSString *textInput = @"Testing «ταБЬℓσ»: 1<2 & 4+1>3, now 20% off!";
  NSArray *groupsInput = @[ @"pie-test" ];
  NSArray *tags = @[ @"submission-app", @"product1", @"sampleCategory" ];

  UIImage *testImage = [self loadTestImageNamed:@"test_pattern.jpg"];

  BVCurationsAddPostRequest *params =
      [[BVCurationsAddPostRequest alloc] initWithGroups:groupsInput
                                        withAuthorAlias:aliasInput
                                              withToken:tokenInput
                                               withText:textInput];

  params.image = testImage;
  params.tags = tags;

  // Hit the API
  BVCurationsPhotoUploader *uploadAPI = [[BVCurationsPhotoUploader alloc] init];

  [uploadAPI submitCurationsContentWithParams:params
      completionHandler:^(void) {
        // completion
        XCTAssertTrue(
            NO, @"Success block called in test which should have failed.");
        [expectation fulfill];
      }
      withFailure:^(NSError *error) {
        // error
        NSLog(@"ERROR: %@", error.localizedDescription);

        XCTAssertNotNil(error, @"Got a nil NSError object");
        XCTAssertEqual(error.code, 500, @"Expected error code 500");

        [expectation fulfill];
      }];

  [self waitForExpectations];
}

- (void)testPostMissingRequiredKey {
  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testPostMissingRequiredKey"];

  [self stubWithJSON:@"post_MissingRequiredKey.json"];

  // Construct the parmas with required
  NSString *aliasInput = @"";
  NSString *tokenInput = @"";
  NSString *textInput = @"";
  NSArray *groupsInput = @[];

  BVCurationsAddPostRequest *params =
      [[BVCurationsAddPostRequest alloc] initWithGroups:groupsInput
                                        withAuthorAlias:aliasInput
                                              withToken:tokenInput
                                               withText:textInput];

  // Hit the API
  BVCurationsPhotoUploader *uploadAPI = [[BVCurationsPhotoUploader alloc] init];

  [uploadAPI submitCurationsContentWithParams:params
      completionHandler:^(void) {
        // completion
        XCTAssertTrue(
            NO, @"Success block called in test which should have failed.");
        [expectation fulfill];
      }
      withFailure:^(NSError *error) {
        // error
        NSLog(@"ERROR: %@", error.localizedDescription);
        XCTAssertNotNil(error, @"Got a nil NSError object");
        XCTAssertEqual(error.code, 400, @"Expected error code 400");

        [expectation fulfill];
      }];

  [self waitForExpectations];
}

- (void)testPostMalformedJSONResponse {
  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testPostMalformedJSONResponse"];

  [self stubWithJSON:@"malformedJSON.json"];

  // Construct the parmas with required
  NSString *aliasInput = @"";
  NSString *tokenInput = @"";
  NSString *textInput = @"";
  NSArray *groupsInput = @[];

  BVCurationsAddPostRequest *params =
      [[BVCurationsAddPostRequest alloc] initWithGroups:groupsInput
                                        withAuthorAlias:aliasInput
                                              withToken:tokenInput
                                               withText:textInput];

  // Hit the API
  BVCurationsPhotoUploader *uploadAPI = [[BVCurationsPhotoUploader alloc] init];

  [uploadAPI submitCurationsContentWithParams:params
      completionHandler:^(void) {
        // completion
        XCTAssertTrue(
            NO, @"Success block called in test which should have failed.");
        [expectation fulfill];
      }
      withFailure:^(NSError *error) {
        // error
        XCTAssertNotNil(error, @"Got a nil NSError object");
        XCTAssertEqual(error.code, -1, @"Expected error code -1");

        [expectation fulfill];
      }];

  [self waitForExpectations];
}

- (void)testPostNilRequestObject {
  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testPostNilRequestObject"];

  // Hit the API - which should never make an API call and just return the
  // error
  // handler
  BVCurationsPhotoUploader *uploadAPI = [[BVCurationsPhotoUploader alloc] init];

  [uploadAPI submitCurationsContentWithParams:nil
      completionHandler:^(void) {
        // completion
        NSLog(@"success");
        XCTAssertTrue(
            NO, @"Success block called in test which should have failed.");
        [expectation fulfill];
      }
      withFailure:^(NSError *error) {
        // error
        NSLog(@"ERROR: %@", error.localizedDescription);
        XCTAssertNotNil(error, @"Got a nil NSError object");
        XCTAssertEqual(error.code, -1, @"Expected error code -1");

        [expectation fulfill];
      }];

  [self waitForExpectations];
}

- (void)testPostNilRequestObjectWithNetworkDelegate {
  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:
                @"testPostNilRequestObjectWithNetworkDelegate"];

  // Hit the API - which should never make an API call and just return the
  // error
  // handler
  BVCurationsPhotoUploader *uploadAPI = [[BVCurationsPhotoUploader alloc] init];

  [uploadAPI submitCurationsContentWithParams:nil
      completionHandler:^(void) {
        // completion
        NSLog(@"success");
        XCTAssertTrue(
            NO, @"Success block called in test which should have failed.");
        [expectation fulfill];
      }
      withFailure:^(NSError *error) {
        // error
        NSLog(@"ERROR: %@", error.localizedDescription);
        XCTAssertNotNil(error, @"Got a nil NSError object");
        XCTAssertEqual(error.code, -1, @"Expected error code -1");

        [expectation fulfill];
      }];

  [self waitForExpectations];
}
*/

@end
