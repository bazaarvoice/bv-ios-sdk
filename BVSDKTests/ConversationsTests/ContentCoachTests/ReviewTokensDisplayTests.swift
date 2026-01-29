//
//  ReviewTokensDisplayTests.swift
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

final class ReviewTokensDisplayTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        let configDict = ["clientId": "bv-beauty",
                          "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKeyBVBeauty)];
        BVSDKManager.configure(withConfiguration: configDict, configType: .prod)
      }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReviewTokensDisplay() {
      
      let expectation = self.expectation(description: "testReviewTokensDisplay")
      let request = BVReviewTokensRequest(productId: "P000036")
      
      request.load({ (response) in
          print(response.data ?? "")
          XCTAssertNotNil(response.data)
        expectation.fulfill()
        
      }) { (error) in
        
        XCTFail("product display request error: \(error)")
        expectation.fulfill()
        
      }
      
      self.waitForExpectations(timeout: 10) { (error) in
        XCTAssertNil(error, "Something went horribly wrong, request took too long.")
      }
      
    }
}
