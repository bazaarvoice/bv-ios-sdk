//
//  ProductTextSearchTests.swift
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import XCTest

class ProductTextSearchTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": "caB45h2jBqXFw1OE043qoMBD1gJC8EwFNCjktzgwncXY4"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testProductTextSearchIncentivizedStats() {
    let expectation = self.expectation(description: "testProductTextSearchIncentivizedStats")
    
    let request = BVProductTextSearchRequest(searchText: "large dryer")
      .includeStatistics(.reviews)
      .addCustomDisplayParameter("filteredstats", withValue: "reviews")
    
    request.incentivizedStats = true
    request.load({ (response) in
      
      XCTAssertNotNil(response.results)
      XCTAssertEqual(response.results.count, 9)
      
      // incentivized stats assertions
      for result in response.results {
        XCTAssertNotNil(result.reviewStatistics?.incentivizedReviewCount)
      }
      
      let product = response.results.first!
      
      XCTAssertNotNil(product.identifier)
      
      // Review Statistics assertions
      XCTAssertNotNil(product.reviewStatistics)
      XCTAssertEqual(product.reviewStatistics?.incentivizedReviewCount, 6)
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
