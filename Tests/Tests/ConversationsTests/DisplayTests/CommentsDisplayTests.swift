//
//  CommentsDisplayTests.swift
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class CommentsDisplayTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": "kuy3zj9pr3n7i0wxajrzj04xo"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    BVSDKManager.shared().setLogLevel(BVLogLevel.verbose)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testCommentDisplayByReviewId() {
    let expectation = self.expectation(description: "testCommentDisplayByReviewId")
    
    let limit : UInt16  = 99
    let offset : UInt16 = 0
    
    let request = BVCommentsRequest(productId: "1000001", andReviewId: "192548", limit: limit, offset: offset)
    
    request.load({ (response) in
      
      XCTAssertEqual(response.results.count, 5)
      XCTAssertEqual(response.limit?.uint16Value, limit)
      XCTAssertEqual(response.offset?.uint16Value, offset)
      XCTAssertGreaterThan(response.totalResults!.intValue, 4)
      XCTAssertEqual(response.locale, "en_US")
      
      expectation.fulfill()
      
    }) { (error) in
      
      XCTFail("comments by product id display request error: \(error)")
      
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
  func testCommentDisplayByCommentId() {
    let expectation = self.expectation(description: "testCommentDisplayByCommentId")
    
    let request = BVCommentsRequest(productId: "1000001", andCommentId: "12024")
    
    
    request.load({ (response) in
      
      XCTAssertEqual(response.results.count, 1)
      
      let theComment = response.results.first!
      
      XCTAssertEqual(theComment.title, "TEST>> I came in the store wanting to try 4 other")
      XCTAssertEqual(theComment.authorId, "63kfce2dchdd2f8te9en4xx5y")
      XCTAssertEqual(theComment.isSyndicated, false)
      XCTAssertEqual(theComment.reviewId, "192548")
      XCTAssertEqual(theComment.userLocation, nil)
      XCTAssertEqual(theComment.commentText, "TEST>> I came in the store wanting to try 4 other dresses, and didnt even notice this one. I walked by a huge poster, and this beautiful dress caught my eye! It ended up being the first dress I tried on, and it was right then, that I knew this was the right dress. After this dress, I tried on 4 other ones, but decided on buying this one. It fits sooooo perfectly, and it gives your body a wonderful shape.test\nI love this dress sooooooo much!!")
      
      let calendar = Calendar.current
      
      let year = calendar.component(.year, from: theComment.submissionTime!)
      let month = calendar.component(.month, from: theComment.submissionTime!)
      let day = calendar.component(.day, from: theComment.submissionTime!)
      
      XCTAssertEqual(2011, year)
      XCTAssertEqual(6, month)
      XCTAssertEqual(27, day)
      
      XCTAssertNotNil(theComment.lastModeratedTime)
      XCTAssertNotNil(theComment.lastModificationTime)
      
      expectation.fulfill()
      
    }) { (error) in
      
      XCTFail("comments by product id display request error: \(error)")
      
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
    
  }
  
  
  func testCommentIncludes() {
    let expectation = self.expectation(description: "testCommentDisplayByCommentId")
    
    let request = BVCommentsRequest(productId: "1000001", andCommentId: "12024")
    request.addInclude(.authors)
    request.addInclude(.products)
    request.addInclude(.reviews)
    
    request.load({ (response) in
      
      XCTAssertEqual(response.results.count, 1)
      
      let theComment : BVComment = response.results.first!
      
      // Test included reviews
      let theReview : BVReview = (theComment.includes?.getReviewById(theComment.reviewId!))!
      XCTAssertNotNil(theReview)
      XCTAssertNotNil(theReview.title)
      
      // Test included products
      let theProduct : BVProduct = (theComment.includes?.getProductById(theReview.productId!))!
      XCTAssertNotNil(theProduct)
      XCTAssertNotNil(theProduct.name)
      
      // Test included authors
      let theAuthor : BVAuthor = (theComment.includes?.getAuthorById(theComment.authorId!))!
      XCTAssertNotNil(theAuthor)
      XCTAssertNotNil(theAuthor.userNickname)
      XCTAssertNotNil(theAuthor.authorId)
      
      expectation.fulfill()
      
    }) { (error) in
      
      XCTFail("comments by product id display request error: \(error)")
      
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
    
  }
  
  func testCommentFilteringSorting() {
    let expectation = self.expectation(description: "testCommentDisplayByCommentId")
    
    let limit : UInt16  = 90
    let offset : UInt16 = 0
    
    let request = BVCommentsRequest(productId: "1000001", andReviewId: "192548", limit: limit, offset: offset)
    request.addFilter(.contentLocale, filterOperator: .equalTo, value: "en_US")
    request.addCommentSort(.commentsSubmissionTime, order: .descending)
    
    request.load({ (response) in
      
      XCTAssertEqual(response.results.count, 5)
      
      expectation.fulfill()
      
    }) { (error) in
      
      XCTFail("comments by product id display request error: \(error)")
      
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
    
  }
  
  
  
  func testCommentWithErrors() {
    let expectation = self.expectation(description: "testCommentWithErrors")
    
    let request = BVCommentsRequest(productId: "1000001", andCommentId: "snoochieboochies")
    request.addCustomDisplayParameter("bar", withValue: "food")
    
    request.load({ (response) in
      
      XCTFail("Call should have failed")
      
      expectation.fulfill()
      
    }) { (error) in
      
      XCTAssertTrue((error.first?.localizedDescription.contains("ERROR_PARAM_INVALID_FILTER_ATTRIBUTE"))!)
      
      expectation.fulfill()
      
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
}
