//
//  BVAdsSDKTestsTests.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <BVSDK/BVCore.h>

static BVAuthenticatedUser *user = nil;

@interface BVAdvertisingTests : XCTestCase {

    XCTestExpectation *userProfileExpectation;
    XCTestExpectation *magpieEventExpectation;

}
@end

@implementation BVAdvertisingTests

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
    [sdkManager setClientId:@"apitestcustomer"]; // test customer
    [sdkManager setApiKeyShopperAdvertising:TEST_KEY_SHOPPER_ADVERTISING]; // test ads passkey
    [sdkManager setStaging:NO];
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
}

- (void)userProfileUpdated:(NSNotification *)notification{
    
    XCTAssertNotNil(notification, @"Notifcation was nil from user profile fetch");
   
    user = (BVAuthenticatedUser *)[notification object];
    XCTAssertNotNil(user, @"User profile is nil after profile fetch");
    NSDictionary *keywords = [user getTargetingKeywords];
    XCTAssertNotNil(keywords, @"User profile keywords are nil after profile fetch");
    
    [userProfileExpectation fulfill];
    
}

- (void)magpieEventReceived:(NSNotification *)notification{
    
    XCTAssertNotNil(notification, "Magpie event notification was nil");
    
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)[notification object];
    
    XCTAssertFalse(resp.statusCode >= 300, @"Expected 2xx response, got: %ld", (long)resp.statusCode);
    
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

- (void)test1_UserProfile {
    
    userProfileExpectation = [self expectationWithDescription:@"Expecting user profile network event"];
    
    [[BVSDKManager sharedManager] setUserWithAuthString:@"0ce436b29697d6bc74f30f724b9b0bb6646174653d31323334267573657269643d5265636f6d6d656e646174696f6e7353646b54657374"]; // pre-populated with a small profile interested in "pets", "powersports", "gamefish", and others -- for testing purposes.
    
    [self waitForExpectations];
}


- (void)test2_SendPersonalizationEvent{
    
    magpieEventExpectation = [self expectationWithDescription:@"Expecting magpie network event"];
    
    XCTAssertNotNil(user, "Failed magpie event due to nil user");
    
    [[BVAnalyticsManager sharedManager] sendPersonalizationEvent:user];
    
    [self waitForExpectations];
}

@end
