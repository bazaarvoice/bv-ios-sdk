//
//  AnalyticsTests.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <AdSupport/ASIdentifierManager.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <BVSDK/BVAnalyticsManager.h>
#import <BVSDK/BVBulkRatingsRequest.h>
#import <BVSDK/BVCommon.h>
#import <BVSDK/BVNotificationsAnalyticsHelper.h>
#import <BVSDK/BVProductDisplayPageRequest.h>
#import <BVSDK/BVQuestionsAndAnswersRequest.h>
#import <BVSDK/BVRecommendations.h>
#import <BVSDK/BVReviewsRequest.h>

#import "BVBaseStubTestCase.h"

#define ANALYTICS_TEST_USING_MOCK_DATA                                         \
  1 // Setting to 1 uses mock result. Set to 0 to make network request.

@interface BVAnalyticsManager (TestAccessors)
@property(strong) NSMutableArray *eventQueue;
@end

@interface BVInternalAnalyticsTests : BVBaseStubTestCase {
  XCTestExpectation *impressionExpectation;
  XCTestExpectation *pageviewExpectation;
  NSInteger numberOfExpectedImpressionAnalyticsEvents;
  NSInteger numberOfExpectedPageviewAnalyticsEvents;
}
@end

#define TEST_CLIENT_ID @"IOS_UNIT_TEST"
#define IS_STAGING YES
#define TEST_KEY_SHOPPER_ADVERTISING @"fakeshopperadskey"
#define TEST_KEY_CONVERSATIONS @"faketestkeyconversations"
#define TEST_LOCALE_CONVERSATIONS @"en_US"

@implementation BVInternalAnalyticsTests

- (void)setUp {
  [super setUp];
  NSDictionary *configDict = @{
    @"apiKeyConversations" : TEST_KEY_CONVERSATIONS,
    @"apiKeyShopperAdvertising" : TEST_KEY_SHOPPER_ADVERTISING,
    @"clientId" : TEST_CLIENT_ID,
    @"analyticsLocaleIdentifier" : TEST_LOCALE_CONVERSATIONS
  };

  [BVSDKManager configureWithConfiguration:configDict
                                configType:BVConfigurationTypeStaging];

  // Global logging level
  [[BVSDKManager sharedManager] setLogLevel:BVLogLevelAnalyticsOnly];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(analyticsPageviewEventCompleted:)
             name:@"BV_INTERNAL_PAGEVIEW_ANALYTICS_COMPLETED"
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(analyticsImpressionEventCompleted:)
             name:@"BV_INTERNAL_MAGPIE_EVENT_COMPLETED"
           object:nil];

  impressionExpectation = [self
      expectationWithDescription:@"Expecting impression analytics events"];
  pageviewExpectation =
      [self expectationWithDescription:@"Expecting pageview analytics events"];
  numberOfExpectedImpressionAnalyticsEvents = 0;
  numberOfExpectedPageviewAnalyticsEvents = 0;
}

- (void)tearDown {
  [super tearDown];

  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:@"BV_INTERNAL_PAGEVIEW_ANALYTICS_COMPLETED"
              object:nil];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:@"BV_INTERNAL_MAGPIE_EVENT_COMPLETED"
              object:nil];
}

- (void)waitForAnalytics {
  [self waitForExpectationsWithTimeout:30.0
                               handler:^(NSError *error) {
                                 if (error) {
                                   XCTFail(@"Expectation Failed with error: %@",
                                           error);
                                 }
                               }];
}

- (void)analyticsImpressionEventCompleted:(NSNotification *)notification {
  NSLog(@"analytics impression event fired in tests: %i",
        (int)numberOfExpectedImpressionAnalyticsEvents);

#if ANALYTICS_TEST_USING_MOCK_DATA != 1
  NSError *err = (NSError *)[notification object];
  if (err) {
    XCTFail(@"ERROR: Analytic event failed %@", err);
  } else {
    NSLog(@"Analytic Impression HTTP success.");
  }
#endif /* ANALYTICS_TEST_USING_MOCK_DATA != 1 */

  numberOfExpectedImpressionAnalyticsEvents -= 1;
  [self checkComplete];
}

- (void)analyticsPageviewEventCompleted:(NSNotification *)notification {
  NSLog(@"analytics pageview event fired in tests: %i",
        (int)numberOfExpectedPageviewAnalyticsEvents);

#if ANALYTICS_TEST_USING_MOCK_DATA != 1
  NSError *err = (NSError *)[notification object];
  if (err) {
    XCTFail(@"ERROR: Analytic event failed %@", err);
  } else {
    NSLog(@"Analytic Page View HTTP success.");
  }
#endif /* ANALYTICS_TEST_USING_MOCK_DATA != 1 */

  numberOfExpectedPageviewAnalyticsEvents -= 1;
  [self checkComplete];
}

- (void)checkComplete {
  if (numberOfExpectedImpressionAnalyticsEvents == 0) {
    [impressionExpectation fulfill];
    numberOfExpectedImpressionAnalyticsEvents = -1;
  }
  if (numberOfExpectedPageviewAnalyticsEvents == 0) {
    [pageviewExpectation fulfill];
    numberOfExpectedPageviewAnalyticsEvents = -1;
  }
}

#pragma mark BVConversations analytics

/*
-(void)testAnalyticsCompletesSmall {

#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"testShowReview.json"];
#endif

    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 1;
    [self fireReviewAnalyticsCompletesWithLimit:1];

    [[BVAnalyticsManager sharedManager] flushQueue];
}

-(void)testAnalyticsCompletesBatched {

#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"testShowReview.json"];
#endif

    numberOfExpectedPageviewAnalyticsEvents = 1;

    numberOfExpectedImpressionAnalyticsEvents = 1;

    [self fireReviewAnalyticsCompletesWithLimit:60];

    [[BVAnalyticsManager sharedManager] flushQueue];
}
*/

- (void)testBigAnalyticsEvent {
  // bomb the analytics event with a ton of events, to make sure it doesn't
  // crash. The event queue is protected by a dispatch barrier to ensure the
  // analytics manager is thread-safe.

#if ANALYTICS_TEST_USING_MOCK_DATA == 1
  NSArray<NSString *> *fileSequence = @[
    @"testShowReview.json", @"testShowReview.json", @"testShowReview.json"
  ];
  [self addStubWith200ResponseForJSONFilesNamed:fileSequence];
#endif

  numberOfExpectedPageviewAnalyticsEvents = 1;
  numberOfExpectedImpressionAnalyticsEvents = 1;

  BVReviewsRequest *request =
      [[BVReviewsRequest alloc] initWithProductId:@"test1" limit:10 offset:20];
  [request load:^(BVReviewsResponse *__nonnull response) {
    // pass
  }
      failure:^(NSArray<NSError *> *__nonnull errors) {
        // fail
        XCTFail("Failure block should not get hit.");
      }];

  BVReviewsRequest *request2 =
      [[BVReviewsRequest alloc] initWithProductId:@"test2" limit:10 offset:20];
  [request2 load:^(BVReviewsResponse *__nonnull response) {
    // pass
  }
      failure:^(NSArray<NSError *> *__nonnull errors) {
        // fail
        XCTFail("Failure block should not get hit.");
      }];

  BVProductDisplayPageRequest *pdpRequest =
      [[BVProductDisplayPageRequest alloc] initWithProductId:@"test4"];
  [pdpRequest includeStatistics:BVProductIncludeTypeValueReviews];
  [pdpRequest includeStatistics:BVProductIncludeTypeValueQuestions];
  [pdpRequest load:^(BVProductsResponse *__nonnull response) {
    [[BVAnalyticsManager sharedManager] flushQueue];
  }
      failure:^(NSArray *__nonnull errors) {
        XCTFail("Failure block should not get hit.");
      }];

  [self waitForAnalytics];
}

- (void)testAnalyticsQuestion {
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
  [self addStubWith200ResponseForJSONFileNamed:@"testShowQuestion.json"];
#endif
  numberOfExpectedImpressionAnalyticsEvents = 1;
  numberOfExpectedPageviewAnalyticsEvents = 1;

  BVQuestionsAndAnswersRequest *request =
      [[BVQuestionsAndAnswersRequest alloc] initWithProductId:@"test1"
                                                        limit:20
                                                       offset:0];
  [request load:^(BVQuestionsAndAnswersResponse *__nonnull response) {
    // success
    [[BVAnalyticsManager sharedManager] flushQueue];
  }
      failure:^(NSArray<NSError *> *__nonnull errors) {
        // error
        XCTFail("Accidental failure!");
      }];

  [self waitForAnalytics];
}

- (void)testAnalyticsProducts {
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
  [self addStubWith200ResponseForJSONFileNamed:@"testShowProducts.json"];
#endif

  numberOfExpectedImpressionAnalyticsEvents = 1;
  numberOfExpectedPageviewAnalyticsEvents = 1;

  // Should send one product page view and one or impression for a review
  BVProductDisplayPageRequest *pdpRequest =
      [[BVProductDisplayPageRequest alloc] initWithProductId:@"test4"];
  [pdpRequest includeStatistics:BVProductIncludeTypeValueReviews];
  [pdpRequest includeStatistics:BVProductIncludeTypeValueQuestions];
  [pdpRequest load:^(BVProductsResponse *__nonnull response) {
    [[BVAnalyticsManager sharedManager] flushQueue];
  }
      failure:^(NSArray *__nonnull errors) {
        XCTFail("Failure block should not get hit.");
      }];

  [self waitForAnalytics];
}

/*
-(void)testAnalyticsStatistics {

#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"testShowStatistics.json"];
#endif

    numberOfExpectedImpressionAnalyticsEvents = 0;
    numberOfExpectedPageviewAnalyticsEvents = 0;

    NSArray* productIds = @[@"test1", @"test2", @"test3", @"test4"];
    BVBulkRatingsRequest* request = [[BVBulkRatingsRequest alloc]
initWithProductIds:productIds statistics:BulkRatingsStatsTypeAll];
    [request load:^(BVBulkRatingsResponse * nonnull response) {
        [[BVAnalyticsManager sharedManager] flushQueue];
    } failure:^(NSArray * nonnull errors) {
        XCTFail("Failure block should not get hit.");

    }];

    [self waitForAnalytics];
}
*/

#pragma mark BVRecommendations - Feature Used Tests

- (void)testProductWidgetPageView {
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
  [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif

  numberOfExpectedImpressionAnalyticsEvents = 1;
  numberOfExpectedPageviewAnalyticsEvents = 0;

  // General recommendations - Test by sending a bunch of events on threads
  // with different priorities.

  dispatch_async(
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        BVRecommendationsRequest *request =
            [[BVRecommendationsRequest alloc] initWithLimit:20];
        [BVRecsAnalyticsHelper
            queueEmbeddedRecommendationsPageViewEvent:request
                                       withWidgetType:RecommendationsCarousel];
      });

  dispatch_async(
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
        BVRecommendationsRequest *request =
            [[BVRecommendationsRequest alloc] initWithLimit:20
                                              withProductId:@"product123"];
        [BVRecsAnalyticsHelper
            queueEmbeddedRecommendationsPageViewEvent:request
                                       withWidgetType:RecommendationsCarousel];
      });

  dispatch_async(
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        BVRecommendationsRequest *request =
            [[BVRecommendationsRequest alloc] initWithLimit:20
                                             withCategoryId:@"categoryId"];
        [BVRecsAnalyticsHelper
            queueEmbeddedRecommendationsPageViewEvent:request
                                       withWidgetType:RecommendationsCarousel];
      });

  [self waitForAnalytics];
}

- (void)testProductWidgetSwiped {
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
  [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif

  numberOfExpectedImpressionAnalyticsEvents = 1;
  numberOfExpectedPageviewAnalyticsEvents = 0;

  [self addStubWith200ResponseForJSONFileNamed:@""];

  [BVRecsAnalyticsHelper
      queueAnalyticsEventForWidgetScroll:RecommendationsCarousel];

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

- (void)testProductRecommendationVisible {
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
  [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif

  numberOfExpectedImpressionAnalyticsEvents = 1;
  numberOfExpectedPageviewAnalyticsEvents = 0;

  BVRecommendedProduct *testProduct = [self createFakeProduct];

  [BVRecsAnalyticsHelper queueAnalyticsEventForProductView:testProduct];

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

- (void)testProductFeatureUsed {
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
  [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif

  numberOfExpectedImpressionAnalyticsEvents = 1;
  numberOfExpectedPageviewAnalyticsEvents = 0;

  [self addStubWith200ResponseForJSONFileNamed:@""];

  BVRecommendedProduct *testProduct = [self createFakeProduct];

  [BVRecsAnalyticsHelper queueAnalyticsEventForProductTapped:testProduct];

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

- (BVRecommendedProduct *)createFakeProduct {
  NSDictionary *fakeProduct = @{
    @"client" : @"apitestcustomer",
    @"product" : @"123456",
    @"name" : @"Converse shoes",
    @"image_url" : @"http://www.zomshopping.com/images/l/"
                   @"converse-shoes-black-chuck-taylor-all-star-classic-"
                   @"womens-mens-canvas-sneakers-low-40-178.jpg",
    @"product_page_url" : @"http://www.bazaarvoice.com/fakeurl",
    @"interests" : @[ @"Home & Garden", @"Tools" ],
    @"category_ids" : @[
      @"apitestcustomer/101253", @"apitestcustomer/100845",
      @"apitestcustomer/100896", @"apitestcustomer/102560",
      @"apitestcustomer/104244"
    ],
    @"RS" : @"vav",
    @"sponsored" : @"false"
  };

  NSDictionary *recStats = @{
    @"RKB" : @"1",
    @"RKI" : @"2",
    @"RKP" : @"3",
    @"RKT" : @"5",
    @"RKC" : @"4",
  };

  BVRecommendedProduct *testProduct =
      [[BVRecommendedProduct alloc] initWithDictionary:fakeProduct
                               withRecommendationStats:recStats];

  return testProduct;
}

#pragma mark BVNotifications Tests

- (void)testNotificationInView {
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
  [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif

  numberOfExpectedImpressionAnalyticsEvents = 1;
  numberOfExpectedPageviewAnalyticsEvents = 0;

  [BVNotificationsAnalyticsHelper
      queueAnalyticEventForReviewNotificationInView:@"StorePushNotification"
                                             withId:@"1000"
                                     andProductType:ProductTypeStore];

  XCTAssert([[BVAnalyticsManager sharedManager] eventQueue].count == 1,
            @"There should be 1 event queued.");

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

- (void)testNotificationUsedFeature {
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
  [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif

  numberOfExpectedImpressionAnalyticsEvents = 1;
  numberOfExpectedPageviewAnalyticsEvents = 0;

  [BVNotificationsAnalyticsHelper
      queueAnalyticEventForReviewUsedFeature:@"ok"
                                      withId:@"1000"
                              andProductType:ProductTypeStore];

  XCTAssert([[BVAnalyticsManager sharedManager] eventQueue].count == 1,
            @"There should be 1 event queued.");

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

@end
