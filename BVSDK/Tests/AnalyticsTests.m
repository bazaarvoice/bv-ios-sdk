//
//  AnalyticsTests.m
//  BVSDK
//
//  Created by Jason Harris on 2/22/15.
//  Copyright (c) 2015 Jason Harris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <BVSDK/BVSDK.h>


@interface BVAnalyticsTests : XCTestCase<BVDelegate> {
    XCTestExpectation *impressionExpectation;
    XCTestExpectation *pageviewExpectation;
    int numberOfExpectedImpressionAnalyticsEvents;
    int numberOfExpectedPageviewAnalyticsEvents;
}
@end


@implementation BVAnalyticsTests

- (void)setUp
{
    [super setUp];
    
    [BVSettings instance].staging = YES;
    [BVSettings instance].clientId = @"apitestcustomer";
    [BVSettings instance].passKey = @"2cpdrhohmgmwfz8vqyo48f52g";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(analyticsPageviewEventCompleted)
                                                 name:@"BV_INTERNAL_PAGEVIEW_ANALYTICS_COMPLETED"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(analyticsImpressionEventCompleted)
                                                 name:@"BV_INTERNAL_IMPRESSION_ANALYTICS_COMPLETED"
                                               object:nil];
    
    impressionExpectation = [self expectationWithDescription:@"Expecting impression analytics events"];
    pageviewExpectation = [self expectationWithDescription:@"Expecting pageview analytics events"];
    numberOfExpectedImpressionAnalyticsEvents = 0;
    numberOfExpectedPageviewAnalyticsEvents = 0;
}

-(void)tearDown {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"BV_INTERNAL_PAGEVIEW_ANALYTICS_COMPLETED"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"BV_INTERNAL_IMPRESSION_ANALYTICS_COMPLETED"
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

-(void)analyticsImpressionEventCompleted {
    NSLog(@"analytics impression event fired in tests: %i", numberOfExpectedImpressionAnalyticsEvents);
    numberOfExpectedImpressionAnalyticsEvents -= 1;
    [self checkComplete];
}

-(void)analyticsPageviewEventCompleted {
    NSLog(@"analytics pageview event fired in tests: %i", numberOfExpectedPageviewAnalyticsEvents);
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

-(void)testAnalyticsCompletesSmall {
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 1;
    [self fireReviewAnalyticsCompletesWithLimit:1];
}

-(void)testAnalyticsCompletesBatched {
    
    numberOfExpectedPageviewAnalyticsEvents = 1;
    numberOfExpectedImpressionAnalyticsEvents = 3;
    [self fireReviewAnalyticsCompletesWithLimit:60];
}

-(void)testBigAnalyticsEvent {
    
    // bomb the analytics event with a ton of events, to make sure it doesn't crash.
    // crash would occur when objects were taken out of the queue in different threads - NSMutableArray is not thread safe
    // moving all array modifications to the main thread fixed the problem - only network requests happen on different threads now

//    numberOfExpectedPageviewAnalyticsEvents = 1;
//    numberOfExpectedImpressionAnalyticsEvents = 3;

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
    
    [impressionExpectation fulfill];
    [pageviewExpectation fulfill];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) { }];
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
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 1;
    
    
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeQuestions];
    [showDisplayRequest setFilterForAttribute:@"Id" equality:BVEqualityEqualTo value:@"6055"];
    [showDisplayRequest setLimit:1];
    [showDisplayRequest sendRequestWithDelegate:self];
    
    [self waitForAnalytics];
}

-(void)testAnalyticsStories {
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeStories];
    [showDisplayRequest setFilterForAttribute:@"Id" equality:BVEqualityEqualTo value:@"14181"];
    [showDisplayRequest setLimit:1];
    [showDisplayRequest sendRequestWithDelegate:self];
    
    [self waitForAnalytics];
}


-(void)testAnalyticsProducts {
    
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
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 1;
    
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeStatistics];
    [showDisplayRequest setFilterForAttribute:@"ProductId" equality:BVEqualityEqualTo values:[NSArray arrayWithObjects:@"test1", @"test2", @"test3", nil]];
    [showDisplayRequest addStatsOn:BVIncludeStatsTypeReviews];
    [showDisplayRequest addStatsOn:BVIncludeStatsTypeNativeReviews];
    [showDisplayRequest sendRequestWithDelegate:self];
    
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


