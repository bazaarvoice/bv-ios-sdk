//
//  BVAdsSDKTestsTests.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <BVSDK/BVCore.h>

// 3rd Party
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>

static BVAuthenticatedUser *user = nil;

@interface BVUserProfileTests : XCTestCase {

    XCTestExpectation *userProfileExpectation;
    XCTestExpectation *magpieEventExpectation;
    
}
@end

@implementation BVUserProfileTests

- (void)setUp {
    
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userProfileUpdated:)
                                                 name:@"BV_INTERNAL_PROFILE_UPDATED_COMPLETED"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(magpieEventReceived:)
                                                 name:@"BV_INTERNAL_MAGPIE_EVENT_COMPLETED"
                                               object:nil];
    
    // set up the BVAdsSDK with your clientId, and AdsPassKey
    BVSDKManager *sdkManager = [BVSDKManager sharedManager];
    NSDictionary *configDict = @{@"apiKeyShopperAdvertising": @"fakekey",
                                 @"clientId": @"iosunittest"};
    [BVSDKManager configureWithConfiguration:configDict configType:BVConfigurationTypeStaging];
    [sdkManager setLogLevel:BVLogLevelError];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"BV_INTERNAL_PROFILE_UPDATED_COMPLETED"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"BV_INTERNAL_MAGPIE_EVENT_COMPLETED"
                                                  object:nil];
    
    [OHHTTPStubs removeAllStubs];
}


- (void)magpieEventReceived:(NSNotification *)notification{
    
    XCTAssertNotNil(notification, "Magpie event notification was nil");
    
    // notification object comes back with a filled out NSError, which we expect to be nil
    
    XCTAssertNil(notification.object, @"Notification object should have been nil!");
    
    [magpieEventExpectation fulfill];
    
}

- (void) waitForExpectations{
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
}

// For a typical user profile call, the client will simply pass in the UAS string and be done with it.
// The logic behind the call to BVSDKManager#setUserWithAuthString will handle all requirements for making
// sure the profile is updated.
// The text itself
- (void)testSetUserProfile {
    
    userProfileExpectation = [self expectationWithDescription:@"Expecting user profile network event"];
    magpieEventExpectation = [self expectationWithDescription:@"Expecting magpie profile personalization event"];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host containsString:@"bazaarvoice.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // return normal user profile from /users API
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"userProfile1.json", self.class)
                                                 statusCode:200
                                                    headers:@{@"Content-Type":@"application/json"}]
                responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];

    
    [[BVSDKManager sharedManager] setUserWithAuthString:@"TOKEN_REMOVED"]; // pre-populated with a small profile interested in "pets", "powersports", "gamefish", and others -- for testing purposes.
    
    [self waitForExpectations];
}

// This is the notification callback (for internal testing) that sends the BVAuthenticatedUser object with
// profile info
- (void)userProfileUpdated:(NSNotification *)notification{
    
    XCTAssertNotNil(notification, @"Notifcation was nil from user profile fetch");
    
    user = (BVAuthenticatedUser *)[notification object];
    XCTAssertNotNil(user, @"User profile is nil after profile fetch");
    NSDictionary *keywords = [user getTargetingKeywords];
    
    NSString *brandsKeyWords = [keywords objectForKey:@"brands"];
    NSString *interestsKeyWords = [keywords objectForKey:@"interests"];
    
    XCTAssertTrue([brandsKeyWords containsString:@"brand1_MED"], @"Expected brand1_MED in keyword result");
    XCTAssertTrue([brandsKeyWords containsString:@"anotherbrand_MED"], @"Expected anotherbrand_MED in keyword result");
    
    XCTAssertTrue([interestsKeyWords containsString:@"womensshoes_LOW"], @"Expected womensshoes_LOW in keyword result");
    XCTAssertTrue([interestsKeyWords containsString:@"uncategorized_MED"], @"Expected uncategorized_MED in keyword result");
    XCTAssertTrue([interestsKeyWords containsString:@"apparelaccessories_HIGH"], @"Expected apparelaccessories_HIGH in keyword result");
    
    [userProfileExpectation fulfill];
    
}


@end
