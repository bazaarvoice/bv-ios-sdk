//
//  BVNotificationConfigTests.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVNotificationConfigTests.h"
#import "BVSDKManager.h"
#import "BVSDKManager+Private.h"

@implementation BVNotificationConfigTests : BVBaseStubTestCase

- (void)setUp {
    
    [[BVSDKManager sharedManager] setClientId:@"testingtesting"];
    [[BVSDKManager sharedManager] setApiKeyConversationsStores:@"fakeymcfakersonfakekey"];
    [[BVSDKManager sharedManager] setStaging:YES];
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelError];
    
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testLoadNotificationConfigAPI {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testLoadNotificationConfigAPI"];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host containsString:@"s3.amazonaws.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // return normal user profile from /users API
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"testNotificationConfig.json", self.class)
                                                 statusCode:200
                                                    headers:@{@"Content-Type":@"application/json;charset=utf-8"}]
                responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
    
    // Testing private API
    [[BVSDKManager sharedManager] loadNotificationConfiguration];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Check and see if we have all the notification configuration options
        
        BVStoreReviewNotificationProperties *noteProps = [BVSDKManager sharedManager].bvStoreReviewNotificationProperties;
        
        XCTAssertNotNil(noteProps, @"Config note properties should not be nil");
        XCTAssertEqual(noteProps.visitDuration, 5, @"Unexpected visitDuration");
        XCTAssertEqual(noteProps.notificationDelay, 5, @"Unexpected notificationDelay");
        XCTAssertEqual(noteProps.remindMeLaterDuration, 86400, @"Unexpected remindMeLaterDuration");
        
        XCTAssertTrue([noteProps.customUrlScheme isEqualToString:@"bvsdkdemo"], @"customUrlScheme failure");
        
        XCTAssertTrue([noteProps.reviewPromtDispayText isEqualToString:@"Thank you for visiting Endurance Cycles."], @"fail reviewPromtDispayText");
        XCTAssertTrue([noteProps.reviewPromptSubtitleText isEqualToString:@"How would you describe your experience?"], @"fail reviewPromptSubtitleText");
        XCTAssertTrue([noteProps.reviewPromtNoReview isEqualToString:@"I did not visit this store"], @"fail reviewPromtNoReview");
        XCTAssertTrue([noteProps.reviewPromptYesReview isEqualToString:@"Positive Experience"], @"fail reviewPromptYesReview");
        XCTAssertTrue([noteProps.reviewPromptRemindText isEqualToString:@"Bad Experience"], @"fail reviewPromptRemindText");
        
        XCTAssertTrue(noteProps.requestReviewOnAppOpen, @"fail requestReviewOnAppOpen flag");
        XCTAssertTrue(noteProps.notificationsEnabled, @"fail notificationsEnabled flag");
        
        [expectation fulfill];
        
    });
    
    
    [self waitForExpectations];
    
    
}

/*
- (void)testLoadNotificationFailure {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testLoadNotificationFailure"];
    
    // Testing private API
    [[BVSDKManager sharedManager] loadNotificationConfiguration];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Check and see if we have all the notification configuration options
        
        BVStoreReviewNotificationProperties *noteProps = [BVSDKManager sharedManager].bvStoreReviewNotificationProperties;
        
        XCTAssertNil(noteProps, @"Config note properties should be nil");
       
        [expectation fulfill];
        
    });
    
    
    [self waitForExpectations];
    
    
}
*/
- (void) waitForExpectations{
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
}

@end
