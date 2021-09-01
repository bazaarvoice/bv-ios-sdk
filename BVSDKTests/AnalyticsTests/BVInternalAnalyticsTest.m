
//
//  AnalyticsTests.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <BVSDK/BVAnalyticsManager+Testing.h>
#import <BVSDK/BVAnalyticsRemoteLogger+Testing.h>
#import <BVSDK/BVBulkRatingsRequest.h>
#import <BVSDK/BVCommon.h>
#import <BVSDK/BVLogger+Private.h>
#import <BVSDK/BVNotificationsAnalyticsHelper.h>
#import <BVSDK/BVProductDisplayPageRequest.h>
#import <BVSDK/BVQuestionsAndAnswersRequest.h>
#import <BVSDK/BVRecommendations.h>
#import <BVSDK/BVRemoteLogEvent.h>
#import <BVSDK/BVReviewsRequest.h>
#import <BVSDK/BVUserAgent+NSURLRequest.h>

#import "BVBaseStubTestCase.h"

@interface BVAnalyticsManager (TestAccessors)
@property(strong) NSMutableArray *eventQueue;
@end

@interface BVInternalAnalyticsTests : BVBaseStubTestCase
@property(nonatomic, copy) OHHTTPStubsTestBlock passableTest;
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

  self.passableTest = ^BOOL(NSURLRequest *_Nonnull request) {
    return ![request.HTTPMethod isEqualToString:@"POST"] &&
           [request.URL.host containsString:@"bazaarvoice.com"];
  };
}

- (void)tearDown {
  [super tearDown];

  BVAnalyticsRemoteLogger.sharedRemoteLogger.remoteLogTestingCompletionBlock =
      nil;
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

- (dispatch_block_t)generateAnalyticsCompletionBlock {
  NSDate *now = [NSDate date];
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"HH:mm:ss"];
  NSString *dateString = [dateFormat stringFromDate:now];

  NSString *description =
      [NSString stringWithFormat:@"BVInternalAnalyticsTest-%@", dateString];
  XCTestExpectation *expectation =
      [self expectationWithDescription:description];

  return ^{
    [expectation fulfill];
  };
}

#pragma mark BVConversations analytics

- (void)testBigAnalyticsEvent {
  // bomb the analytics event with a ton of events, to make sure it doesn't
  // crash. The event queue is protected by a dispatch barrier to ensure the
  // analytics manager is thread-safe.

  NSArray<NSString *> *fileSequence = @[
    @"testShowReview.json", @"testShowReview.json", @"testShowProducts.json"
  ];
  [self forceStubWithJSONSequence:fileSequence
                  withPassingTest:self.passableTest];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testBigAnalyticsEvent"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

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
  [self forceStubWithJSON:@"testShowQuestion.json"
          withPassingTest:self.passableTest];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testAnalyticsQuestion"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  [[BVAnalyticsManager sharedManager]
      enqueuePageViewTestWithName:@"testAnalyticsQuestion"
              withCompletionBlock:[self generateAnalyticsCompletionBlock]];

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
  [self forceStubWithJSON:@"testShowProducts.json"
          withPassingTest:self.passableTest];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testAnalyticsProducts"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  [[BVAnalyticsManager sharedManager]
      enqueuePageViewTestWithName:@"testAnalyticsProducts"
              withCompletionBlock:[self generateAnalyticsCompletionBlock]];

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

#pragma mark BVRecommendations - Feature Used Tests

- (void)testProductWidgetPageView {
  NSArray<NSString *> *fileSequence =
      @[ @"emptyJSON.json", @"emptyJSON.json", @"emptyJSON.json" ];
  [self forceStubWithJSONSequence:fileSequence
                  withPassingTest:self.passableTest];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testProductWidgetPageView"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  // General recommendations - Test by sending a bunch of events on threads
  // with different priorities.

  dispatch_async(
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^{
          BVRecommendationsRequest *request =
              [[BVRecommendationsRequest alloc] initWithLimit:20];
          [BVRecsAnalyticsHelper
              queueEmbeddedRecommendationsPageViewEvent:request
                                               pageType:[self class]
                                         withWidgetType:
                                             RecommendationsCarousel];
        });
      });

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(
                     void) {
    dispatch_async(dispatch_get_main_queue(), ^{
      BVRecommendationsRequest *request =
          [[BVRecommendationsRequest alloc] initWithLimit:20
                                            withProductId:@"product123"];
      [BVRecsAnalyticsHelper
          queueEmbeddedRecommendationsPageViewEvent:request
                                           pageType:[self class]
                                     withWidgetType:RecommendationsCarousel];
    });
  });

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(
                     void) {
    dispatch_async(dispatch_get_main_queue(), ^{
      BVRecommendationsRequest *request =
          [[BVRecommendationsRequest alloc] initWithLimit:20
                                           withCategoryId:@"categoryId"];
      [BVRecsAnalyticsHelper
          queueEmbeddedRecommendationsPageViewEvent:request
                                           pageType:[self class]
                                     withWidgetType:RecommendationsCarousel];
    });
  });

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

- (void)testProductWidgetSwiped {
  [self forceStubWithJSON:@"emptyJSON.json" withPassingTest:self.passableTest];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testProductWidgetSwiped"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  [BVRecsAnalyticsHelper
      queueAnalyticsEventForWidgetScroll:RecommendationsCarousel];

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

- (void)testProductFeatureUsed {
  [self forceStubWithJSON:@"emptyJSON.json" withPassingTest:self.passableTest];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testProductFeatureUsed"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  BVRecommendedProduct *testProduct = [self createFakeProduct];

  [BVRecsAnalyticsHelper queueAnalyticsEventForProductTapped:testProduct];

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

#pragma mark BVNotifications Tests

- (void)testNotificationInView {
  [self forceStubWithJSON:@"emptyJSON.json" withPassingTest:self.passableTest];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testNotificationInView"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

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
  [self forceStubWithJSON:@"emptyJSON.json"];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testNotificationUsedFeature"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  [BVNotificationsAnalyticsHelper
      queueAnalyticEventForReviewUsedFeature:@"ok"
                                      withId:@"1000"
                              andProductType:ProductTypeStore];

  XCTAssert([[BVAnalyticsManager sharedManager] eventQueue].count == 1,
            @"There should be 1 event queued.");

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

#pragma mark Remote Logger Tests

- (void)testAnalyticsDirectRemoteLogSubmission {
  XCTestExpectation *expectation = [self
      expectationWithDescription:@"testAnalyticsDirectRemoteLogSubmission"];

  BVRemoteLogEvent *logEvent = [[BVRemoteLogEvent alloc]
         initWithError:[BVLogger logLevelDescription:BVLogLevelFault]
      localeIdentifier:NSLocale.autoupdatingCurrentLocale.localeIdentifier
                   log:@"testing logging error facility"
             bvProduct:@"Analytics"];

  [BVAnalyticsRemoteLogger.sharedRemoteLogger
         sendRemoteLogEvent:logEvent
      withCompletionHandler:^(NSError *_Nullable error) {
        if (error) {
          NSLog(@"Error: %@", error);
          XCTFail();
        }
        [expectation fulfill];
      }];

  [self waitForAnalytics];
}

- (void)testAnalyticsRemoteLogSubmission {
  XCTestExpectation *expectation =
      [self expectationWithDescription:@"testAnalyticsRemoteLogSubmission"];

  BVAnalyticsRemoteLogger.sharedRemoteLogger.remoteLogTestingCompletionBlock =
      ^(BVRemoteLogEvent *__nonnull remoteLog, NSError *__nullable error) {
        if (error) {
          NSLog(@"Error: %@\n%@", error, remoteLog.toRaw);
          XCTFail();
        }
        [expectation fulfill];
      };

  BVLogFault(@"testing logging error facility", BV_PRODUCT_ANALYTICS);

  [self waitForAnalytics];
}

- (void)testAnalyticsBVUserAgent {
  NSString *userAgent = [NSURLRequest bvUserAgentWithLocaleIdentifier:@"en_US"];
  NSString *osVersion = [[[UIDevice currentDevice] systemVersion]
      stringByReplacingOccurrencesOfString:@"."
                                withString:@"_"];
  NSString *model = [[UIDevice currentDevice] model];
  NSString *os = [model compare:@"iPad"] ? @"OS" : @"iPhone OS";

  XCTAssertTrue([userAgent containsString:osVersion]);
  XCTAssertTrue([userAgent containsString:model]);
  XCTAssertTrue([userAgent containsString:os]);
}

#pragma mark Object Helper

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

@end
