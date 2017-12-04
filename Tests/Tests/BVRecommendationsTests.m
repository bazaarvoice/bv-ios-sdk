//
//  BVRecommendationsTests.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <AdSupport/ASIdentifierManager.h>
#import <BVSDK/BVRecommendations.h>
#import <XCTest/XCTest.h>

#import "BVBaseStubTestCase.h"

@interface BVRecommendationsTests : BVBaseStubTestCase {
}
@end

@implementation BVRecommendationsTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each
  // test method in the class.

  NSDictionary *configDict =
      @{@"apiKeyShopperAdvertising" : @"fakekey", @"clientId" : @"iosunittest"};
  [BVSDKManager configureWithConfiguration:configDict
                                configType:BVConfigurationTypeStaging];
  [[BVSDKManager sharedManager] setLogLevel:BVLogLevelError];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of
  // each test method in the class.
  [super tearDown];
}

// Basic test that fetches the client's IDFA and returns an array of product
// recommenations.
- (void)testFetchProductRecommendations {
  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testFetchProductRecommendations"];

  [self addStubWith200ResponseForJSONFileNamed:@"recommendationsResult.json"];

  BVRecommendationsRequest *request =
      [[BVRecommendationsRequest alloc] initWithLimit:10];
  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
  [loader loadRequest:request
      completionHandler:^(
          NSArray<BVRecommendedProduct *> *__nonnull recommendations) {

        XCTAssertTrue([recommendations count] > 0,
                      @"Recommendation result should not be size 0");
        [expectation fulfill];

      }
      errorHandler:^(NSError *__nonnull error) {

        XCTFail(@"Error handler should not have been called");

        [expectation fulfill];

      }];

  [self waitForExpectations];
}

- (void)testRecommendationsByProductId {
  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testRecommendationsByProductId"];

  [self addStubWith200ResponseForJSONFileNamed:
            @"recommendationsByProductId.json"];

  BVRecommendationsRequest *request =
      [[BVRecommendationsRequest alloc] initWithLimit:10
                                        withProductId:@"client/productId1234"];
  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
  [loader loadRequest:request
      completionHandler:^(
          NSArray<BVRecommendedProduct *> *__nonnull recommendations) {

        XCTAssertTrue([recommendations count] > 0,
                      @"Recommendation result should not be size 0");
        [expectation fulfill];

      }
      errorHandler:^(NSError *__nonnull error) {

        XCTFail(@"Error handler should not have been called");
        [expectation fulfill];

      }];

  [self waitForExpectations];
}

- (void)testRecommendationsByCategoryId {
  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testRecommendationsByCategoryId"];

  [self addStubWith200ResponseForJSONFileNamed:
            @"recommendationsByCategoryId.json"];

  BVRecommendationsRequest *request =
      [[BVRecommendationsRequest alloc] initWithLimit:10
                                       withCategoryId:@"client/categoryId0100"];
  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
  [loader loadRequest:request
      completionHandler:^(
          NSArray<BVRecommendedProduct *> *__nonnull recommendations) {

        XCTAssertTrue([recommendations count] > 0,
                      @"Recommendation result should not be size 0");
        [expectation fulfill];

      }
      errorHandler:^(NSError *__nonnull error) {

        XCTFail(@"Error handler should not have been called");
        [expectation fulfill];

      }];

  [self waitForExpectations];
}

// Malformed JSON test
- (void)testFetchProductRecommendationsMalformedJSONResponse {
  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:
                @"testFetchProductRecommendationsMalformedJSONResponse"];

  [self addStubWith200ResponseForJSONFileNamed:@"malformedJSON.json"];

  BVRecommendationsRequest *request =
      [[BVRecommendationsRequest alloc] initWithLimit:3];
  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
  [loader loadRequest:request
      completionHandler:^(
          NSArray<BVRecommendedProduct *> *__nonnull recommendations) {

        XCTAssertTrue(
            NO, @"Success block called in test which should have failed.");
        [expectation fulfill];

      }
      errorHandler:^(NSError *__nonnull error) {

        XCTAssertNotNil(error, @"Got a nil NSError object");
        XCTAssertEqual(error.code, 3840, @"Expected error code -1");

        [expectation fulfill];

      }];

  [self waitForExpectations];
}

// <null> values in JSON. Ensures if bad json is sent from server the serializer
// won't barf
- (void)testFetchProductRecommendationsNullJSON {
  __weak XCTestExpectation *expectation = [self
      expectationWithDescription:@"testFetchProductRecommendationsNullJSON"];

  [self addStubWith200ResponseForJSONFileNamed:@"recommendationsNullJSON.json"];

  BVRecommendationsRequest *request =
      [[BVRecommendationsRequest alloc] initWithLimit:2];
  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
  [loader loadRequest:request
      completionHandler:^(
          NSArray<BVRecommendedProduct *> *__nonnull recommendations) {

        XCTAssertTrue([recommendations count] == 1,
                      @"Recommendation result should size should be 1");
        [expectation fulfill];

      }
      errorHandler:^(NSError *__nonnull error) {

        XCTFail(@"Error handler should not have been called");

        [expectation fulfill];

      }];

  [self waitForExpectations];
}

// Test, just ensure BVShopperProfile initializes arrays by default
- (void)testPraseEmptyShopperProfile {
  BVShopperProfile *profile =
      [[BVShopperProfile alloc] initWithDictionary:[NSDictionary dictionary]];

  XCTAssertTrue(profile.recommendations.count == 0,
                @"Profile recommenations size was not zero");
  XCTAssertTrue(profile.interests.count == 0,
                @"Profile interests size was not zero");
  XCTAssertTrue(profile.brands.count == 0, @"Profile brands size was not zero");
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

@end
