//
//  AnalyticsTests.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <AdSupport/ASIdentifierManager.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <BVSDK/BVCore.h>
#import <BVSDK/BVConversations.h>
#import <BVSDK/BVRecommendations.h>

#import "BVBaseStubTestCase.h"

#define ANALYTICS_TEST_USING_MOCK_DATA 1 // Setting to 1 uses mock result. Set to 0 to make network request.

@interface BVAnalyticsManager (TestAccessors)
@property (strong) NSMutableArray* eventQueue;
@end

@interface BVAnalyticsTests : BVBaseStubTestCase<BVDelegate> {
    XCTestExpectation *impressionExpectation;
    XCTestExpectation *pageviewExpectation;
    int numberOfExpectedImpressionAnalyticsEvents;
    int numberOfExpectedPageviewAnalyticsEvents;
}
@end

#define TEST_CLIENT_ID @"IOS_UNIT_TEST"
#define IS_STAGING YES
#define TEST_KEY_SHOPPER_ADVERTISING @"fakeshopperadskey"

@implementation BVAnalyticsTests

- (void)setUp
{
    [super setUp];
        
    [BVSDKManager sharedManager].staging = IS_STAGING;
    [BVSDKManager sharedManager].clientId = TEST_CLIENT_ID;
    // BVConverstaions SDK API Key
    [BVSDKManager sharedManager].apiKeyConversations = TEST_KEY_CONVERSATIONS;
    
    // BVRecommendations & BVAdvertising SDK key.
    [BVSDKManager sharedManager].apiKeyShopperAdvertising = TEST_KEY_SHOPPER_ADVERTISING;
    
    // Global logging level
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelError];
    
    NSLog(@"BVSDK Info: %@", [BVSDKManager sharedManager].description);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(analyticsPageviewEventCompleted:)
                                                 name:@"BV_INTERNAL_PAGEVIEW_ANALYTICS_COMPLETED"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(analyticsImpressionEventCompleted:)
                                                 name:@"BV_INTERNAL_MAGPIE_EVENT_COMPLETED"
                                               object:nil];
    
    impressionExpectation = [self expectationWithDescription:@"Expecting impression analytics events"];
    pageviewExpectation = [self expectationWithDescription:@"Expecting pageview analytics events"];
    numberOfExpectedImpressionAnalyticsEvents = 0;
    numberOfExpectedPageviewAnalyticsEvents = 0;
}

-(void)tearDown {
    
    [super tearDown];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"BV_INTERNAL_PAGEVIEW_ANALYTICS_COMPLETED"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"BV_INTERNAL_MAGPIE_EVENT_COMPLETED"
                                                  object:nil];
}

-(void)waitForAnalytics {
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

-(void)analyticsImpressionEventCompleted:(NSNotification *)notification {
    
    NSLog(@"analytics impression event fired in tests: %i", numberOfExpectedImpressionAnalyticsEvents);
    
    NSError *err = (NSError *)[notification object];
    if (err){
        XCTFail(@"ERROR: Analytic event failed %@", err);
    } else {
        NSLog(@"Analytic Impression HTTP success.");
    }
    
    numberOfExpectedImpressionAnalyticsEvents -= 1;
    [self checkComplete];

}

-(void)analyticsPageviewEventCompleted:(NSNotification *)notification {

    NSLog(@"analytics pageview event fired in tests: %i", numberOfExpectedPageviewAnalyticsEvents);
    
    NSError *err = (NSError *)[notification object];
    if (err){
        XCTFail(@"ERROR: Analytic event failed %@", err);
    } else {
        NSLog(@"Analytic Page View HTTP success.");
    }
    
    numberOfExpectedPageviewAnalyticsEvents -= 1;
    [self checkComplete];

}

-(void)checkComplete {
    if(numberOfExpectedImpressionAnalyticsEvents == 0){
        [impressionExpectation fulfill];
        numberOfExpectedImpressionAnalyticsEvents = -1;
    }
    if(numberOfExpectedPageviewAnalyticsEvents == 0){
        [pageviewExpectation fulfill];
        numberOfExpectedPageviewAnalyticsEvents = -1;
    }
}

#pragma mark BVConversations analytics

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

-(void)testBigAnalyticsEvent {
    
    // bomb the analytics event with a ton of events, to make sure it doesn't crash.
    // The event queue is protected by a dispatch barrier to ensure the analytics manager is thread-safe.

#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"testShowReview.json"];
#endif
    
    numberOfExpectedPageviewAnalyticsEvents = 1;
    numberOfExpectedImpressionAnalyticsEvents = 1;
    
    BVGet *showDisplayRequest = [[ BVGet alloc ] initWithType:BVGetTypeReviews];
    [showDisplayRequest setLimit:100];
    [showDisplayRequest setSearch: @"Great sound"];
    [showDisplayRequest addSortForAttribute:@"Id" ascending:YES];
    [showDisplayRequest sendRequestWithDelegate:self];
    
    BVGet *showDisplayRequest2 = [[ BVGet alloc ] initWithType:BVGetTypeReviews];
    [showDisplayRequest2 setLimit:100];
    [showDisplayRequest2 setSearch: @"Great sound"];
    [showDisplayRequest2 addSortForAttribute:@"Id" ascending:YES];
    [showDisplayRequest2 sendRequestWithDelegate:self];
    
    BVGet *showDisplayRequest3 = [[ BVGet alloc ] initWithType:BVGetTypeReviews];
    [showDisplayRequest3 setLimit:100];
    [showDisplayRequest3 setSearch: @"Great sound"];
    [showDisplayRequest3 addSortForAttribute:@"Id" ascending:YES];
    [showDisplayRequest3 sendRequestWithDelegate:self];
    
    [[BVAnalyticsManager sharedManager] flushQueue];
    
    [self waitForAnalytics];
    
}

-(void)fireReviewAnalyticsCompletesWithLimit:(int)limit {
    
    BVGet *showDisplayRequest = [[ BVGet alloc ] initWithType:BVGetTypeReviews];
    [showDisplayRequest setLimit:limit];
    [showDisplayRequest setSearch: @"Great sound"];
    [showDisplayRequest addSortForAttribute:@"Id" ascending:YES];
    [showDisplayRequest sendRequestWithDelegate:self];
    
    [self waitForAnalytics];
}

-(void)testAnalyticsQuestion {
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"testShowQuestion.json"];
#endif
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 1;
    
    
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeQuestions];
    [showDisplayRequest setFilterForAttribute:@"Id" equality:BVEqualityEqualTo value:@"6055"];
    [showDisplayRequest setLimit:1];
    [showDisplayRequest sendRequestWithDelegate:self];
    
    [self waitForAnalytics];
}

-(void)testAnalyticsStories {
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"testShowStory.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeStories];
    [showDisplayRequest setFilterForAttribute:@"Id" equality:BVEqualityEqualTo value:@"14181"];
    [showDisplayRequest setLimit:1];
    [showDisplayRequest sendRequestWithDelegate:self];
    
    [self waitForAnalytics];
}


-(void)testAnalyticsProducts {
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"testShowProducts.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 1;
    
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeProducts];
    [showDisplayRequest setFilterForAttribute:@"CategoryId" equality:BVEqualityEqualTo value:@"testcategory1011"];
    [showDisplayRequest setFilterOnIncludedType:BVIncludeTypeReviews forAttribute:@"Id" equality:BVEqualityEqualTo value:@"83501"];
    [showDisplayRequest setLimit:1];
    [showDisplayRequest sendRequestWithDelegate:self];
    
    [self waitForAnalytics];
}

-(void)testAnalyticsCategories {
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"testShowCategory.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeCategories];
    [showDisplayRequest setFilterForAttribute:@"Id" equality:BVEqualityEqualTo value:@"testCategory1011"];
    [showDisplayRequest setFilterOnIncludedType:BVIncludeTypeProducts forAttribute:@"Id" equality:BVEqualityEqualTo value:@"test2"];
    [showDisplayRequest setLimit:1];
    [showDisplayRequest sendRequestWithDelegate:self];
    
    [self waitForAnalytics];
}

-(void)testAnalyticsStatistics {
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"testShowStatistics.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 1;
    
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeStatistics];
    [showDisplayRequest setFilterForAttribute:@"ProductId" equality:BVEqualityEqualTo values:[NSArray arrayWithObjects:@"test1", @"test2", @"test3", nil]];
    [showDisplayRequest addStatsOn:BVIncludeStatsTypeReviews];
    [showDisplayRequest addStatsOn:BVIncludeStatsTypeNativeReviews];
    [showDisplayRequest sendRequestWithDelegate:self];
    
    [self waitForAnalytics];
}


#pragma mark BVRecommendations - Feature Used Tests


- (void)testProductWidgetPageView{
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    // General recommendations - Test by sending a bunch of events on threads with different priorities.

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        BVRecommendationsRequest* request = [[BVRecommendationsRequest alloc] initWithLimit:20];
        [BVRecsAnalyticsHelper queueEmbeddedRecommendationsPageViewEvent:request withWidgetType:RecommendationsCarousel];
    });
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void){
        BVRecommendationsRequest* request = [[BVRecommendationsRequest alloc] initWithLimit:20 withProductId:@"product123"];
        [BVRecsAnalyticsHelper queueEmbeddedRecommendationsPageViewEvent:request withWidgetType:RecommendationsCarousel];
    });

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        BVRecommendationsRequest* request = [[BVRecommendationsRequest alloc] initWithLimit:20 withCategoryId:@"categoryId"];
        [BVRecsAnalyticsHelper queueEmbeddedRecommendationsPageViewEvent:request withWidgetType:RecommendationsCarousel];
    });
    
    [self waitForAnalytics];
    
}

- (void)testProductWidgetSwiped{
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    [self addStubWith200ResponseForJSONFileNamed:@""];
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForWidgetScroll:RecommendationsCarousel];
    
    [[BVAnalyticsManager sharedManager] flushQueue];
    
    [self waitForAnalytics];
}

- (void)testProductRecommendationVisible{
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
     [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    BVProduct *testProduct = [self createFakeProduct];
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForProductView:testProduct];
    
    [[BVAnalyticsManager sharedManager] flushQueue];
    
    [self waitForAnalytics];
    
}

- (void)testProductFeatureUsed{
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    [self addStubWith200ResponseForJSONFileNamed:@""];
    
    BVProduct *testProduct = [self createFakeProduct];

    [BVRecsAnalyticsHelper queueAnalyticsEventForProductTapped:testProduct];
    
    [[BVAnalyticsManager sharedManager] flushQueue];
    
    [self waitForAnalytics];
    
}


- (BVProduct *)createFakeProduct{
    
    NSDictionary* fakeProduct = @{
                                  @"client": @"apitestcustomer",
                                  @"product": @"123456",
                                  @"name": @"Converse shoes",
                                  @"image_url": @"http://www.zomshopping.com/images/l/converse-shoes-black-chuck-taylor-all-star-classic-womens-mens-canvas-sneakers-low-40-178.jpg",
                                  @"product_page_url": @"http://www.bazaarvoice.com/fakeurl",
                                  @"interests": @[
                                                @"Home & Garden",
                                                @"Tools"
                                                ],
                                  @"category_ids": @[
                                                   @"apitestcustomer/101253",
                                                   @"apitestcustomer/100845",
                                                   @"apitestcustomer/100896",
                                                   @"apitestcustomer/102560",
                                                   @"apitestcustomer/104244"
                                                   ],
                                  @"RS": @"vav",
                                  @"sponsored": @"false"
                                  };
    
    NSDictionary* recStats = @{
                               @"RKB": @"1",
                               @"RKI": @"2",
                               @"RKP": @"3",
                               @"RKT": @"5",
                               @"RKC": @"4",
                               };
    
    BVProduct *testProduct = [[BVProduct alloc] initWithDictionary:fakeProduct withRecommendationStats:recStats];
    
    return testProduct;
}

#pragma mark - BVPixel Tests

- (void)testTransactionConversionNoPII{

#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    NSArray* orderItems = @[[[BVTransactionItem alloc]initWithSku:@"123" name:@"test product" category:@"home and garden" price:99.99 quantity:1 imageUrl:nil]];
    BVTransaction* transaction = [[BVTransaction alloc]initWithOrderId:@"testorderid" orderTotal:99.99 orderItems:orderItems andOtherParams:@{@"state":@"TX", @"city": @"Austin"}];
    [BVPixel trackConversionTransaction:transaction];
    
    XCTAssert([[BVAnalyticsManager sharedManager]eventQueue].count == 1, @"Conversions without PII should only produce one event");
    
    [[BVAnalyticsManager sharedManager] flushQueue];
    
    [self waitForAnalytics];
}

- (void)testTransactionConversionPII{
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    NSArray* orderItems = @[[[BVTransactionItem alloc]initWithSku:@"123" name:@"test product" category:@"home and garden" price:99.99 quantity:1 imageUrl:nil]];
    BVTransaction* transaction = [[BVTransaction alloc]initWithOrderId:@"testorderid" orderTotal:99.99 orderItems:orderItems andOtherParams:@{@"state":@"TX", @"city": @"Austin",
                                                                                                                               /*PII*/   @"email":@"some.one@domain.com"}];
    [BVPixel trackConversionTransaction:transaction];
    
    XCTAssert([[BVAnalyticsManager sharedManager]eventQueue].count == 2, @"Conversions with PII should produce two events");
    
    [[BVAnalyticsManager sharedManager] flushQueue];
    
    [self waitForAnalytics];

}

- (void)testNonTransactionConversionNoPII{
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    BVConversion *conversion = [[BVConversion alloc]initWithType:@"Broucher Download" value:@"HotSpringsSpas" label:@"TestLabel" otherParams:@{@"state":@"TX", @"city": @"Austin"}];
    [BVPixel trackNonCommerceConversion:conversion];
    
    XCTAssert([[BVAnalyticsManager sharedManager]eventQueue].count == 1, @"Non-transactional Conversions without PII should only produce one event");
    
    [[BVAnalyticsManager sharedManager] flushQueue];
    
    [self waitForAnalytics];
}

- (void)testNonTransactionConversionPII{
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    BVConversion *conversion = [[BVConversion alloc]initWithType:@"Broucher Download" value:@"HotSpringsSpas" label:@"TestLabel" otherParams:@{@"state":@"TX", @"city": @"Austin",
                                                                                                                        /*PII*/      @"email":@"some.one@domain.com"}];
    [BVPixel trackNonCommerceConversion:conversion];
    
    XCTAssert([[BVAnalyticsManager sharedManager]eventQueue].count == 2, @"Non-transactional Conversions with PII should produce two events");
    
    [[BVAnalyticsManager sharedManager] flushQueue];
    
    [self waitForAnalytics];
}

#pragma mark - BVDelegate callbacks

- (void)didReceiveResponse:(NSDictionary *)response forRequest:(id)request{
    NSLog(@"Got bv response in analytics test");
}

- (void)didFailToReceiveResponse:(NSError *)err forRequest:(id)request {
    XCTFail(@"Failed to receive response");
}

@end


