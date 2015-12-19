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

@interface BVRecommendationsTests : XCTestCase

@end

@implementation BVRecommendationsTests

- (void)setUp {
    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [[BVSDKManager sharedManager] setApiKeyShopperAdvertising:@"4qhps77enfpw3kghuu8wendy"]; // test recs passkey
    [[BVSDKManager sharedManager] setClientId:@"apitestcustomer"];
    [[BVSDKManager sharedManager] setStaging:NO];
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelError];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


// Basic test that fetches the client's IDFA and returns the recommendations. In this case we most likely we'll just have empty data
- (void)testProfileWithClientIDFA {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Test Profile with Client IDFA Expectation"];
    
    BVGetShopperProfile *recs = [[BVGetShopperProfile alloc] init];
    
    NSString *testIDFAString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [recs fetchProductRecommendations:50 withCompletionHandler:^(BVShopperProfile * _Nullable profile, NSError * _Nullable error) {
        // completion
        XCTAssertNil(error, @"Error should be nil: %@", error.debugDescription);
        
        XCTAssertNotNil(profile, @"Profile should not be nil");
        
        XCTAssertNotNil(profile.userId);
        
        NSString *testUserId = [NSString stringWithFormat:@"magpie_idfa_%@", testIDFAString];
        
        XCTAssertTrue([profile.userId isEqualToString:testUserId], @"The profile ID and Input IDFA were not the same!");
        
        [expectation fulfill];
    }];
        
    [self waitForExpectations];
}


// Internal API test
- (void)testPrivateProfileRecommendations {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Test Profile with Hard-Code IDFA Expectation"];
    
    BVGetShopperProfile *recs = [[BVGetShopperProfile alloc] init];
    
    if(![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
        XCTAssert(@"Limit Ad Tracking needs to be disabled for this test.");
        return;
    }
    
    NSString *testIDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Plug in your own IDFA here if you want....
    [recs _privateFetchShopperProfileWithIDFA:testIDFA
                        withOptions:0
                          withLimit:10
                  completionHandler:^(BVShopperProfile * _Nullable profile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        XCTAssertNil(error, @"Error should be nil: %@", error.debugDescription);
        
        XCTAssertNotNil(profile, @"Profile should not be nil");
        
        NSString *testUserId = [NSString stringWithFormat:@"magpie_idfa_%@", testIDFA];
        
        XCTAssertTrue([profile.userId isEqualToString:testUserId], @"The profile ID and Input IDFA were not the same!");
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectations];
}


- (void)testMissingId {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"nil id test"];
    
    BVGetShopperProfile *recs = [[BVGetShopperProfile alloc] init];
    
#pragma clang diagnostic ignored "-Wnonnull"  // Ignored for testing failure
    [recs _privateFetchShopperProfileWithIDFA:nil
                        withOptions:0
                          withLimit:10
                  completionHandler:^(BVShopperProfile * _Nullable profile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        XCTAssertNil(error, @"Error should  be nil: %@", error.debugDescription);
        
        XCTAssertNotNil(profile, @"Profile NOT should be nil");
        
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
