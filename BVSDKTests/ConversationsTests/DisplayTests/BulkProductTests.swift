//
//  BulkProductTests.swift
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import XCTest

class BulkProductTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey3)];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testBulkProductIncentivizedStats() {
    let expectation = self.expectation(description: "testBulkProductIncentivizedStats")
    
    let request = BVBulkProductRequest()
      .includeStatistics(.reviews)
      .addCustomDisplayParameter("filteredstats", withValue: "reviews")
    
    request.incentivizedStats = true
    request.load({ (response) in
      
      XCTAssertNotNil(response.results)
      XCTAssertEqual(response.results.count, 10)
      
      // incentivized stats assertions
      for result in response.results {
        XCTAssertNotNil(result.reviewStatistics?.incentivizedReviewCount)
      }
      
      let product = response.results.first!
      
      XCTAssertNotNil(product.identifier)
      
      // Review Statistics assertions
      XCTAssertNotNil(product.reviewStatistics)
      XCTAssertEqual(product.reviewStatistics?.incentivizedReviewCount, 1)
      XCTAssertNotNil(product.reviewStatistics?.contextDataDistribution?.value(forKey: "IncentivizedReview"))
      
      let incentivizedReview = product.reviewStatistics?.contextDataDistribution?.value(forKey: "IncentivizedReview") as! BVDistributionElement
      XCTAssertEqual(incentivizedReview.identifier, "IncentivizedReview")
      XCTAssertEqual(incentivizedReview.label, "Received an incentive for this review")
      XCTAssertEqual(incentivizedReview.values.count, 1)
      
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
