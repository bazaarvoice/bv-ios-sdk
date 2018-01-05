//
//  ProductDisplayTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class ProductDisplayTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": "KEY_REMOVED"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
  }
  
  
  func testProductDisplay() {
    
    let expectation = self.expectation(description: "")
    
    let request = BVProductDisplayPageRequest(productId: "test1")
      .include(.pdpReviews, limit: 10)
      .include(.pdpQuestions, limit: 5)
      .includeStatistics(.pdpReviews)
    
    request.load({ (response) in
      
      XCTAssertNotNil(response.result)
      
      let product = response.result!
      let brand = product.brand!
      XCTAssertEqual(brand.identifier, "cskg0snv1x3chrqlde0zklodb")
      XCTAssertEqual(brand.name, "mysh")
      XCTAssertEqual(product.productDescription, "Our pinpoint oxford is crafted from only the finest 80\'s two-ply cotton fibers.Single-needle stitching on all seams for a smooth flat appearance. Tailored with our Traditional\n                straight collar and button cuffs. Machine wash. Imported.")
      XCTAssertEqual(product.brandExternalId, "cskg0snv1x3chrqlde0zklodb")
      XCTAssertEqual(product.imageUrl, "http://myshco.com/productImages/shirt.jpg")
      XCTAssertEqual(product.name, "Dress Shirt")
      XCTAssertEqual(product.categoryId, "testCategory1031")
      XCTAssertEqual(product.identifier, "test1")
      XCTAssertEqual(product.includedReviews.count, 10)
      XCTAssertEqual(product.includedQuestions.count, 5)
      expectation.fulfill()
      
    }) { (error) in
      
      XCTFail("product display request error: \(error)")
      expectation.fulfill()
      
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
  
  func testProductDisplayWithFilter() {
    
    let expectation = self.expectation(description: "")
    
    let request = BVProductDisplayPageRequest(productId: "test1")
      .include(.pdpReviews, limit: 10)
      .include(.pdpQuestions, limit: 5)
      // only include reviews where isRatingsOnly is false
      .filter(on: .isRatingsOnly, relationalFilterOperatorValue: .equalTo, value: "false")
      // only include questions where isFeatured is not equal to true
      .filter(on: .questionIsFeatured, relationalFilterOperatorValue: .notEqualTo, value: "true")
      .includeStatistics(.pdpReviews)
    
    request.load({ (response) in
      
      XCTAssertNotNil(response.result)
      
      let product = response.result!
      
      XCTAssertEqual(product.includedReviews.count, 10)
      XCTAssertEqual(product.includedQuestions.count, 5)
      
      // Iterate all the included reviews and verify that all the reviews have isRatingsOnly = false
      for review in product.includedReviews {
        XCTAssertFalse(review.isRatingsOnly)
      }
      
      // Iterate all the included questions and verify that all the questions have isFeatured = false
      for question in product.includedQuestions {
        XCTAssertFalse(question.isFeatured)
      }
      
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
