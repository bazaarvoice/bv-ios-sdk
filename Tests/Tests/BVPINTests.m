//
//  BVPINTests.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <BVSDK/BVSDK.h>
#import <BVSDK/BVPINRequest.h>

#import "BVBaseStubTestCase.h"

@interface BVPINTests : BVBaseStubTestCase

@end

@implementation BVPINTests

- (void)setUp {
    [super setUp];
    
    [[BVSDKManager sharedManager] setApiKeyPIN:@"fakekey"]; // fake PIN passkey
    [[BVSDKManager sharedManager] setClientId:@"iosunittest"];
    [[BVSDKManager sharedManager] setStaging:YES];
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelError];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testFetchProductsToReview {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testFetchProductsToReview"];
    
    [self addStubWith200ResponseForJSONFileNamed:@"productsToReviewResult.json"];
    
    [BVPINRequest getPendingPINs:^(NSArray<BVPIN *> * _Nonnull pins) {
        // great success!
        
        XCTAssertTrue([pins count] == 3, @"PIN result should size should be 3");
        
        BVPIN *pin = [pins objectAtIndex:0];
        
        XCTAssertTrue([pin.productPageURL isEqualToString:@"http://www.endurancecycles.com/products/granola-bar-with-honey"]);
        XCTAssertEqual([pin.averageRating integerValue], 5);
        XCTAssertTrue([pin.name isEqualToString:@"Granola Bar with Honey"]);
        XCTAssertTrue([pin.ID isEqualToString:@"12-bv"]);
        XCTAssertTrue([pin.imageUrl isEqualToString:@"http://cdn.shopify.com/s/files/1/0796/3917/files/Energy_bar_1.jpg?13414361435441223830"]);
        
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
        // error
        XCTFail(@"Error handler should not have been called");
        [expectation fulfill];
        
    }];
        
    [self waitForExpectations];
}

- (void)testPINMalformedJSON {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testPINMalformedJSON"];
    
    [self addStubWith200ResponseForJSONFileNamed:@"malformedJSON.json"];
    
    [BVPINRequest getPendingPINs:^(NSArray<BVPIN *> * _Nonnull pins) {
        
        XCTFail(@"Success handler should not have been called");
       
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
        // error
       
        XCTAssertEqual(error.code, BV_ERROR_PARSING_FAILED);
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectations];
}


- (void)testPINEmptyJSON {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"testPINEmptyJSON"];
    
    [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
    
    [BVPINRequest getPendingPINs:^(NSArray<BVPIN *> * _Nonnull pins) {
        // great success!
        XCTAssertTrue([pins count] == 0, @"PIN result should size should be 0");
        
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
        // error
        
        XCTFail(@"Error handler should not have been called");
        
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
