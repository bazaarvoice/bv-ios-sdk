//
//  BVRecommendationsTests.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AdSupport/ASIdentifierManager.h>
#import <BVSDK/BVConversations.h>
#import <BVSDK/BVRecommendations.h>

static BVAuthenticatedUser *user = nil;

@interface BVRecommendationsTests : XCTestCase{
    XCTestExpectation *userProfileExpectation;
}
@end

@implementation BVRecommendationsTests

- (void)setUp {
    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userProfileUpdated:)
                                                 name:@"BV_INTERNAL_PROFILE_UPDATED_COMPLETED"
                                               object:nil];
    
    [[BVSDKManager sharedManager] setApiKeyShopperAdvertising:@"3frgjjug4fr3zrgz9a8q9xp7"]; // test recs passkey
    [[BVSDKManager sharedManager] setClientId:@"apitestcustomer"];
    [[BVSDKManager sharedManager] setStaging:NO];
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelInfo];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"BV_INTERNAL_PROFILE_UPDATED_COMPLETED"
                                                  object:nil];
    [super tearDown];
}

- (void)userProfileUpdated:(NSNotification *)notification{
    
    XCTAssertNotNil(notification, @"Notifcation was nil from user profile fetch");
    
    user = (BVAuthenticatedUser *)[notification object];
    XCTAssertNotNil(user, @"User profile is nil after profile fetch");
    NSDictionary *keywords = [user getTargetingKeywords];
    XCTAssertNotNil(keywords, @"User profile keywords are nil after profile fetch");
    
    [userProfileExpectation fulfill];
    
}

//- (void)test1_UserProfile {
//    
//    userProfileExpectation = [self expectationWithDescription:@"Expecting user profile network event"];
//    
//    [[BVSDKManager sharedManager] setUserWithAuthString:@"aa05cf391c8d4738efb4d05f7b2ad7ce7573657269643d4f6d6e694368616e6e656c50726f66696c65313226656d61696c3d6a61736f6e406a61736f6e2e636f6d"]; // pre-populated with a small profile interested in "pets", "powersports", "gamefish", and others -- for testing purposes.
//    
//    [self waitForExpectations];
//}
//

// Basic test that fetches the client's IDFA and returns the recommendations. In this case we most likely we'll just have empty data
- (void)test2_ProfileWithClientIDFA {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Test Profile with Client IDFA Expectation"];
    
    BVGetShopperProfile *recs = [[BVGetShopperProfile alloc] init];
    
    [recs fetchProductRecommendations:50 withCompletionHandler:^(BVShopperProfile * _Nullable profile, NSError * _Nullable error) {
        // completion
        XCTAssertNil(error, @"Error should be nil: %@", error.debugDescription);
        
        XCTAssertNotNil(profile, @"Profile should not be nil");
        
        [expectation fulfill];
    }];
        
    [self waitForExpectations];
}


// Internal API test
- (void)test3_PrivateProfileRecommendations {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Test Profile with Hard-Code IDFA Expectation"];
    
    BVGetShopperProfile *recs = [[BVGetShopperProfile alloc] init];
    
    if(![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
        XCTAssert(@"Limit Ad Tracking needs to be disabled for this test.");
        return;
    }
    
    [recs _privateFetchShopperProfile:nil withCategoryId:nil withProfileOptions:0 withLimit:20 completionHandler:^(BVShopperProfile * _Nullable profile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        // completion
        XCTAssertNil(error, @"Error should be nil: %@", error.debugDescription);
        
        XCTAssertNotNil(profile, @"Profile should not be nil");
        
        [expectation fulfill];
        
    }];
        
    [self waitForExpectations];
}


- (void)test4_RecommendationsForProductId {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Test Recommendations with Product Id"];
    
    BVGetShopperProfile *recs = [[BVGetShopperProfile alloc] init];
        
    [recs fetchProductRecommendationsForProduct:@"qvc/a268640" withLimit:30 withCompletionHandler:^(BVShopperProfile * _Nullable profile, NSError * _Nullable error) {
        // completion
        XCTAssertNil(error, @"Error should be nil: %@", error.debugDescription);
        
        XCTAssertNotNil(profile, @"Profile should not be nil");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations];
    
}

- (void)test5_RecommendationsForCategoryId {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Test Recommendations with Category Id"];
    
    BVGetShopperProfile *recs = [[BVGetShopperProfile alloc] init];
    
    [recs fetchProductRecommendationsForCategory:@"qvc/0100" withLimit:30 withCompletionHandler:^(BVShopperProfile * _Nullable profile, NSError * _Nullable error) {
        // completion
        XCTAssertNil(error, @"Error should be nil: %@", error.debugDescription);
        
        XCTAssertNotNil(profile, @"Profile should not be nil");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations];
    
}



- (void) waitForExpectations{
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
}

@end
