//
//  BVAdsSDKTestsTests.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <BVSDK/BVCore.h>
#import <BVSDK/BVAdsAnalyticsHelper.h>

static BVAuthenticatedUser *user = nil;

@interface BVAdsSDKTestsTests : XCTestCase {

    XCTestExpectation *userProfileExpectation;
    XCTestExpectation *magpieEventExpectation;

}
@end

@implementation BVAdsSDKTestsTests

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
    [sdkManager setApiKeyShopperAdvertising:@"3frgjjug4fr3zrgz9a8q9xp7"]; // test ads passkey
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
    
    [[BVSDKManager sharedManager] setUserWithAuthString:@"aa05cf391c8d4738efb4d05f7b2ad7ce7573657269643d4f6d6e694368616e6e656c50726f66696c65313226656d61696c3d6a61736f6e406a61736f6e2e636f6d"]; // pre-populated with a small profile interested in "pets", "powersports", "gamefish", and others -- for testing purposes.
    
    [self waitForExpectations];
}


- (void)test2_SendPersonalizationEvent{
    
    magpieEventExpectation = [self expectationWithDescription:@"Expecting magpie network event"];
    
    XCTAssertNotNil(user, "Failed magpie event due to nil user");
    
    [[BVAnalyticsManager sharedManager] sendPersonalizationEvent:user];
    
    [self waitForExpectations];
}

@end
