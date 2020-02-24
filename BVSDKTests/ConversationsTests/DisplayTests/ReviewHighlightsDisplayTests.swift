//
//  ReviewHighlightsDisplayTests.swift
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSDK

class ReviewHighlightsDisplayTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let configDict = ["clientId": "hibbett"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.verbose)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReviewHighlightsRequest() {
        
        let expectation = self.expectation(description: "testReviewHighlightsRequest")
        
        let request = BVReviewHighlightsRequest(productId: "5068ZW")
        request.load({ (response) in
            
            expectation.fulfill()
            
            
        }) { (error) in
            XCTFail("profile display request error: \(error)")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
          XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }

}
