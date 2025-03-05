//
//  BVReviewSummaryDisplayTests.swift
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSDK

final class BVReviewSummaryDisplayTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        let configDict = ["clientId": "bv-beauty",
                          "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKeyBVBeauty)];
        BVSDKManager.configure(withConfiguration: configDict, configType: .prod)
      }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReviewSummaryDisplay() {
      
      let expectation = self.expectation(description: "testReviewSummaryDisplay")
      let request = BVReviewSummaryRequest(productId: "P000036", formatType: BVReviewSummaryFormatType.bullet) // or BVReviewSummaryFormatType.paragraph
      
      request.load({ (response) in
          XCTAssertNotNil(response.summary)
          XCTAssertNotNil(response.title)
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
