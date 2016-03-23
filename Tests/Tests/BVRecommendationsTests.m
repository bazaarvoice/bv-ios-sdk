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

// Basic test that fetches the client's IDFA and returns the recommendations. In this case we most likely we'll just have empty data
- (void)test1_ProfileWithClientIDFA {
    
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
- (void)test2_PrivateProfileRecommendations {
    
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


- (void)test3_RecommendationsForProductId {
    
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

- (void)test4_RecommendationsForCategoryId {
    
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


- (void)testPraseEmptyShopperProfile {
    
    BVShopperProfile *profile = [[BVShopperProfile alloc] initWithDictionary:[NSDictionary dictionary]];
    
    XCTAssertTrue(profile.recommendations.count == 0, @"Profile recommenations size was not zero");
    XCTAssertTrue(profile.interests.count == 0, @"Profile interests size was not zero");
    XCTAssertTrue(profile.brands.count == 0, @"Profile brands size was not zero");
    
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
