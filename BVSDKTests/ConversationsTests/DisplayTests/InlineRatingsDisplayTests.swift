//
//  InlineRatingsDisplayTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class InlineRatingsDisplayTests: XCTestCase {
  
  
  override func setUp() {
    super.setUp()
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": "kuy3zj9pr3n7i0wxajrzj04xo"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
  }
  
  
  func testInlineRatingsDisplayMultipleProducts() {
    
    let expectation = self.expectation(description: "")
    
    let request =
      BVBulkRatingsRequest(
        productIds: ["test1", "test2", "test3"],
        statistics: .bulkRatingAll)
        .filter(on: .bulkRatingContentLocale,
                relationalFilterOperatorValue: .equalTo,
                values: ["en_US"])
    
    request.load({ (response) in
      XCTAssertEqual(response.results.count, 3)
      expectation.fulfill()
    }) { (error) in
      XCTFail("inline ratings request error: \(error)")
    }
    
    self.waitForExpectations(timeout: 10) { (error) in print("request took way too long") }
    
  }
  
  func testInlineRatingsDisplayOneProduct() {
    
    let expectation = self.expectation(description: "")
    
    let request =
      BVBulkRatingsRequest(productIds: ["test3"], statistics: .bulkRatingAll)
        .filter(on: .bulkRatingContentLocale, relationalFilterOperatorValue: .equalTo, values: ["en_US"])
    
    request.load({ (response) in
      XCTAssertEqual(response.results.count, 1)
      XCTAssertEqual(response.results[0].productId, "test3")
      XCTAssertEqual(response.results[0].reviewStatistics?.totalReviewCount, 29)
      XCTAssertNotNil(response.results[0].reviewStatistics?.averageOverallRating)
      XCTAssertEqual(response.results[0].reviewStatistics?.overallRatingRange, 5)
      XCTAssertEqual(response.results[0].nativeReviewStatistics?.totalReviewCount, 29)
      XCTAssertEqual(response.results[0].nativeReviewStatistics?.overallRatingRange, 5)
      expectation.fulfill()
    }) { (error) in
      XCTFail("inline ratings request error: \(error)")
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
  func testInlineRatingsTooManyProductsError() {
    
    let expectation = self.expectation(description: "inline ratings display should complete")
    
    var tooManyProductIds: [String] = []
    
    for i in 0 ... 110{
      tooManyProductIds += [String(i)]
    }
    
    let request = BVBulkRatingsRequest(productIds: tooManyProductIds, statistics: .bulkRatingAll)
    
    request.load({ (response) in
      XCTFail("Should not succeed")
    }) { (error) in
      expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
}
