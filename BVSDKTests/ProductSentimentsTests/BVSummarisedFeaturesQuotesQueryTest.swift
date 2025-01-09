//
//  BVSummarisedFeaturesQuotesQueryTest.swift
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSDK

final class BVSummarisedFeaturesQuotesQueryTest: XCTestCase {

    override func setUp() {
      super.setUp()
      let configDict = ["clientId": "bv-beauty",
                        "apiKeyProductSentiments": BVTestUsers().loadValueForKey(key: .conversationsKeyProductSentiments)];
      BVSDKManager.configure(withConfiguration: configDict, configType: .prod)
        BVSDKManager.shared().setLogLevel(BVLogLevel.verbose)
        BVSDKManager.shared().urlSessionDelegate = nil;
    }

    override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
    }
    
    func testProductSummarisedFeaturesQuotes() {
        let expectation = self.expectation(description: "testProductSummarisedFeaturesQuotes")
        let request = BVSummarisedFeaturesQuotesRequest(productId: "P000036", featureId: "111701", language: "en", limit: 10)
        request.load({ response in
            XCTAssertNotNil(response.result.quotes)
            if let quotes = response.result.quotes?.isEmpty {
                XCTFail("No quotes to display")
            } else {
                
            }
            expectation.fulfill()
        }) { (error) in
            
            XCTFail("product display request error: \(error)")
            expectation.fulfill()
          }
        self.waitForExpectations(timeout: 120) { (error) in
          XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }

}
