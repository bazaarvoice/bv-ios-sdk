////
////  BVRecommendationsTests.m
////  Bazaarvoice SDK
////
////  Copyright 2015 Bazaarvoice Inc. All rights reserved.
////
//
//#import <AdSupport/ASIdentifierManager.h>
//#import <BVSDK/BVRecommendations.h>
//#import <BVSDK/BVRecommendationsLoader+Private.h>
//#import <BVSDK/BVRecommendationsRequest+Private.h>
//#import <XCTest/XCTest.h>
//
//#import "BVBaseStubTestCase.h"
//#import "BVNetworkDelegateTestsDelegate.h"
//
//@interface BVRecommendationsTests : BVBaseStubTestCase
//@end
//
//@implementation BVRecommendationsTests
//
//- (void)setUp {
//  NSDictionary *configDict = @{
//    @"apiKeyShopperAdvertising" :
//        @"srZ86SuQ0JupyKrtBHILGIIFsqJoeP4tXYJlQfjojBmuo",
//    @"clientId" : @"APITestCustomer"
//  };
//  [BVSDKManager configureWithConfiguration:configDict
//                                configType:BVConfigurationTypeProd];
//  [[BVSDKManager sharedManager] setLogLevel:BVLogLevelError];
//  [BVSDKManager sharedManager].urlSessionDelegate = nil;
//
//  [super setUp];
//}
//
//- (void)tearDown {
//  [super tearDown];
//}
//
//- (void)testParseURLAndDoLiveQueryRecommendations {
//
//  __weak XCTestExpectation *expectation = [self
//      expectationWithDescription:@"testParseURLAndDoLiveQueryRecommendations"];
//
//  BVRecommendationsRequest *request =
//      [[BVRecommendationsRequest alloc] initWithLimit:10];
//
//  [request addStrategy:@""];
//  [request addStrategy:@"   \n"];
//  [request addStrategy:@"FOO"];
//  [request addStrategy:@"BAR"];
//  [request addStrategy:@"bar"];
//  [request addStrategy:@"BAZ"];
//  [request addStrategy:@"baz"];
//
//  request.averageRating = @(3.333333333333333333333333);
//  request.brandId = @"brand1234567";
//  request.interest = @"football";
//  request.locale = [NSLocale currentLocale];
//  request.lookback =
//      [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitSecond
//                                               value:-10
//                                              toDate:[NSDate date]
//                                             options:0];
//
//  XCTAssertTrue(!request.purposeIsSet);
//  request.purpose = BVRecommendationsRequestPurposeAds;
//  XCTAssertTrue(request.purposeIsSet);
//
//  request.requiredCategory = @"foosball";
//  request = [request addInclude:BVRecommendationsRequestIncludeBrands];
//  request = [request addInclude:BVRecommendationsRequestIncludeCategories];
//  request = [request addInclude:BVRecommendationsRequestIncludeInterests];
//  request = [request addInclude:BVRecommendationsRequestIncludeRecommendations];
//
//  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
//  NSString *currentLocale = [NSString
//      stringWithFormat:@"locale=%@", [NSLocale currentLocale].localeIdentifier];
//  NSString *urlString = [loader getURLForRequest:request].absoluteString;
//
//  XCTAssertTrue([urlString containsString:@"lookback=10s"]);
//  XCTAssertTrue([urlString containsString:@"strategies=bar,baz,foo"]);
//  XCTAssertTrue([urlString containsString:@"bvbrandid=brand1234567"]);
//  XCTAssertTrue([urlString containsString:@"avg_rating=3.33333"]);
//  XCTAssertTrue(
//      [urlString containsString:@"required_category=APITestCustomer/foosball"]);
//  XCTAssertTrue([urlString containsString:@"interest=football"]);
//  XCTAssertTrue([urlString containsString:currentLocale]);
//  XCTAssertTrue([urlString containsString:@"purpose=ads"]);
//  XCTAssertTrue(
//      [urlString containsString:@"include=brands,category_recommendations,"
//                                @"interests,recommendations"]);
//
//  [loader loadRequest:request
//      completionHandler:^(
//          NSArray<BVRecommendedProduct *> *__nonnull recommendations) {
//
//        XCTAssertTrue([recommendations count] > 0,
//                      @"Recommendation result should not be size 0");
//        [expectation fulfill];
//
//      }
//      errorHandler:^(NSError *__nonnull error) {
//
//        XCTFail(@"Error handler should not have been called");
//
//        [expectation fulfill];
//
//      }];
//
//  [self waitForExpectations];
//}
//
//// Basic test that fetches the client's IDFA and returns an array of product
//// recommenations.
//- (void)testFetchProductRecommendations {
//  __weak XCTestExpectation *expectation =
//      [self expectationWithDescription:@"testFetchProductRecommendations"];
//
//  [self stubWithJSON:@"recommendationsResult.json"];
//
//  BVRecommendationsRequest *request =
//      [[BVRecommendationsRequest alloc] initWithLimit:10];
//  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
//  [loader loadRequest:request
//      completionHandler:^(
//          NSArray<BVRecommendedProduct *> *__nonnull recommendations) {
//
//        XCTAssertTrue([recommendations count] > 0,
//                      @"Recommendation result should not be size 0");
//        [expectation fulfill];
//
//      }
//      errorHandler:^(NSError *__nonnull error) {
//
//        XCTFail(@"Error handler should not have been called");
//
//        [expectation fulfill];
//
//      }];
//
//  [self waitForExpectations];
//}
//
//// Same as the above test but we'll test using our networking delegate.
//- (void)testFetchProductRecommendationsWithNetworkingDelegate {
//  __weak XCTestExpectation *expectation =
//      [self expectationWithDescription:
//                @"testFetchProductRecommendationsWithNetworkingDelegate"];
//
//  [self stubWithJSON:@"recommendationsResult.json"];
//
//  BVRecommendationsRequest *request =
//      [[BVRecommendationsRequest alloc] initWithLimit:10];
//  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
//
//  /// Setup the networking test delegate
//  BVNetworkDelegateTestsDelegate *testDelegate =
//      [[BVNetworkDelegateTestsDelegate alloc] init];
//  XCTAssertNotNil(testDelegate, @"BVNetworkDelegateTestsDelegate is nil.");
//
//  testDelegate.urlSessionExpectation =
//      [self expectationWithDescription:@"urlSessionExpectation"];
//
//  [BVSDKManager sharedManager].urlSessionDelegate = testDelegate;
//
//  [loader loadRequest:request
//      completionHandler:^(
//          NSArray<BVRecommendedProduct *> *__nonnull recommendations) {
//        XCTAssertTrue([recommendations count] > 0,
//                      @"Recommendation result should not be size 0");
//        [expectation fulfill];
//      }
//      errorHandler:^(NSError *__nonnull error) {
//        XCTFail(@"Error handler should not have been called");
//        [expectation fulfill];
//      }];
//
//  [self waitForExpectations];
//}
//
//- (void)testRecommendationsByProductId {
//  __weak XCTestExpectation *expectation =
//      [self expectationWithDescription:@"testRecommendationsByProductId"];
//
//  [self stubWithJSON:@"recommendationsByProductId.json"];
//
//  BVRecommendationsRequest *request =
//      [[BVRecommendationsRequest alloc] initWithLimit:10
//                                        withProductId:@"productId1234"];
//  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
//  [loader loadRequest:request
//      completionHandler:^(
//          NSArray<BVRecommendedProduct *> *__nonnull recommendations) {
//
//        XCTAssertTrue([recommendations count] > 0,
//                      @"Recommendation result should not be size 0");
//        [expectation fulfill];
//
//      }
//      errorHandler:^(NSError *__nonnull error) {
//
//        XCTFail(@"Error handler should not have been called");
//        [expectation fulfill];
//
//      }];
//
//  [self waitForExpectations];
//}
//
//- (void)testRecommendationsByCategoryId {
//  __weak XCTestExpectation *expectation =
//      [self expectationWithDescription:@"testRecommendationsByCategoryId"];
//
//  [self stubWithJSON:@"recommendationsByCategoryId.json"];
//
//  BVRecommendationsRequest *request =
//      [[BVRecommendationsRequest alloc] initWithLimit:10
//                                       withCategoryId:@"categoryId0100"];
//  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
//  [loader loadRequest:request
//      completionHandler:^(
//          NSArray<BVRecommendedProduct *> *__nonnull recommendations) {
//
//        XCTAssertTrue([recommendations count] > 0,
//                      @"Recommendation result should not be size 0");
//        [expectation fulfill];
//
//      }
//      errorHandler:^(NSError *__nonnull error) {
//
//        XCTFail(@"Error handler should not have been called");
//        [expectation fulfill];
//
//      }];
//
//  [self waitForExpectations];
//}
//
//// Malformed JSON test
//- (void)testFetchProductRecommendationsMalformedJSONResponse {
//  __weak XCTestExpectation *expectation =
//      [self expectationWithDescription:
//                @"testFetchProductRecommendationsMalformedJSONResponse"];
//
//  [self forceStubWithJSON:@"malformedJSON.json"];
//
//  BVRecommendationsRequest *request =
//      [[BVRecommendationsRequest alloc] initWithLimit:3];
//  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
//  [loader loadRequest:request
//      completionHandler:^(
//          NSArray<BVRecommendedProduct *> *__nonnull recommendations) {
//
//        XCTAssertTrue(
//            NO, @"Success block called in test which should have failed.");
//        [expectation fulfill];
//
//      }
//      errorHandler:^(NSError *__nonnull error) {
//
//        XCTAssertNotNil(error, @"Got a nil NSError object");
//        XCTAssertEqual(error.code, 3840, @"Expected error code -1");
//
//        [expectation fulfill];
//
//      }];
//
//  [self waitForExpectations];
//}
//
//// <null> values in JSON. Ensures if bad json is sent from server the serializer
//// won't barf
//- (void)testFetchProductRecommendationsNullJSON {
//  __weak XCTestExpectation *expectation = [self
//      expectationWithDescription:@"testFetchProductRecommendationsNullJSON"];
//
//  [self forceStubWithJSON:@"recommendationsNullJSON.json"];
//
//  BVRecommendationsRequest *request =
//      [[BVRecommendationsRequest alloc] initWithLimit:2];
//  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
//  [loader loadRequest:request
//      completionHandler:^(
//          NSArray<BVRecommendedProduct *> *__nonnull recommendations) {
//
//        XCTAssertTrue([recommendations count] == 1,
//                      @"Recommendation result should size should be 1");
//        [expectation fulfill];
//
//      }
//      errorHandler:^(NSError *__nonnull error) {
//
//        XCTFail(@"Error handler should not have been called");
//
//        [expectation fulfill];
//
//      }];
//
//  [self waitForExpectations];
//}
//
//// Test, just ensure BVShopperProfile initializes arrays by default
//- (void)testPraseEmptyShopperProfile {
//  BVShopperProfile *profile =
//      [[BVShopperProfile alloc] initWithDictionary:[NSDictionary dictionary]];
//
//  XCTAssertTrue(profile.recommendations.count == 0,
//                @"Profile recommenations size was not zero");
//  XCTAssertTrue(profile.interests.count == 0,
//                @"Profile interests size was not zero");
//  XCTAssertTrue(profile.brands.count == 0, @"Profile brands size was not zero");
//}
//
//- (void)waitForExpectations {
//  [self waitForExpectationsWithTimeout:30.0
//                               handler:^(NSError *error) {
//
//                                 if (error) {
//                                   XCTFail(@"Expectation Failed with error: %@",
//                                           error);
//                                 }
//
//                               }];
//}
//
//@end
