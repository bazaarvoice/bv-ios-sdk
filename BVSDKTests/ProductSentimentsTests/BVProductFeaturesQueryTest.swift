//
//  BVProductFeaturesQueryTest.swift
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSDK

final class BVProductFeaturesQueryTest: XCTestCase {
    
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

    func testProductFeatures() {
        let expectation = self.expectation(description: "testProductFeatures")
        let request = BVProductFeaturesRequest(productId: "P000010", language: "en", limit: 10)
        request.load({ response in
            XCTAssertNotNil(response.result.features)
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
