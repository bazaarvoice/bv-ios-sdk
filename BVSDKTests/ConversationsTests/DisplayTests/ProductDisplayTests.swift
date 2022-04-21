//
//  ProductDisplayTests.swift
//  BVSDKTests
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
      .include(.reviews, limit: 10)
      .include(.questions, limit: 5)
      .include(.authors, limit: 13)
      .includeStatistics(.reviews)
    
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
      XCTAssertEqual(product.includedAuthors.count, 13)
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
      .include(.reviews, limit: 10)
      .include(.questions, limit: 5)
      // only include reviews where isRatingsOnly is false
      .filter(on: .isRatingsOnly, relationalFilterOperatorValue: .equalTo, value: "false")
      // only include questions where isFeatured is not equal to true
      .filter(on: .questionIsFeatured, relationalFilterOperatorValue: .notEqualTo, value: "true")
      .includeStatistics(.reviews)
    
    request.load({ (response) in
      
      XCTAssertNotNil(response.result)
      
      let product = response.result!
      
      XCTAssertEqual(product.includedReviews.count, 10)
      XCTAssertEqual(product.includedQuestions.count, 5)
      
      // Iterate all the included reviews and verify that all the reviews have isRatingsOnly = false
      for review in product.includedReviews {
        XCTAssertFalse(review.isRatingsOnly?.boolValue ?? false)
      }
      
      // Iterate all the included questions and verify that all the questions have isFeatured = false
      for question in product.includedQuestions {
        XCTAssertFalse(question.isFeatured?.boolValue ?? false)
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
  
  
  func testProductDisplayIncentivizedStats() {
      
    // configuration for incentivized stats data
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": "KEY_REMOVED"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)

    let expectation = self.expectation(description: "testProductDisplayIncentivizedStats")
    
    let request = BVProductDisplayPageRequest(productId: "test1234567")
      .includeStatistics(.reviews)
      .addCustomDisplayParameter("filteredstats", withValue: "reviews")
    
    request.incentivizedStats = true
    request.load({ (response) in
      
      XCTAssertNotNil(response.result)
      
      let product = response.result!
      
      XCTAssertEqual(product.identifier, "test1234567")
      
      // Review Statistics assertions
      XCTAssertNotNil(product.reviewStatistics)
      XCTAssertNotNil(product.reviewStatistics?.incentivizedReviewCount)
      XCTAssertEqual(product.reviewStatistics?.incentivizedReviewCount, 3)
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
    
    func testProductRequestTagStats() {
        
        let expectation = self.expectation(description: "testProductStatisticsTagStats")
        
        let request = BVProductDisplayPageRequest(productId: "test1")
                        .addCustomDisplayParameter("stats", withValue: "reviews")
                        .tagStats(true)
            
        request.load({ (response) in
        
           let reviewStatistics =  response.result?.reviewStatistics
           XCTAssertNotNil(reviewStatistics?.tagDistribution!["Con"])
           let conTagDistribution =  reviewStatistics?.tagDistribution!["Con"] as! BVDistributionElement
           let conTagDistributionValues = conTagDistribution.values
            
           XCTAssertEqual(conTagDistributionValues.count, 10)
           XCTAssertEqual(conTagDistributionValues.first?.count,30)
           XCTAssertEqual(conTagDistributionValues.first?.value,"Quality")
             
          
        expectation.fulfill()
            
        }) { (error) in
            
            XCTFail("review display request error: \(error)")
            
        }
        
        self.waitForExpectations(timeout: 1000) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }
}
