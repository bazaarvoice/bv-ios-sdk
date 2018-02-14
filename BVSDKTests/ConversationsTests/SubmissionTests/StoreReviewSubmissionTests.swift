//
//  ConversationsSubmissionTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK

class StoreReviewSubmissionTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    let configDict = ["clientId": "apiunittests",
                      "apiKeyConversationsStores": "KEY_REMOVED"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    BVSDKManager.shared().setLogLevel(.error)
  }
  
  func testSubmitStoreReviewWithPhoto() {
    
    let expectation = self.expectation(description: "testSubmitStoreReviewWithPhoto")
    
    let review = self.fillOutReview()
    review.submit({ (reviewSubmission) in
      expectation.fulfill()
    }, failure: { (errors) in
      XCTFail()
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func fillOutReview() -> BVStoreReviewSubmission {
    let review = BVStoreReviewSubmission(reviewTitle: "The best store ever!",
                                         reviewText: "The store has some of the friendliest staff, and very knowledgable!",
                                         rating: 5,
                                         storeId: "1")
    
    let randomId = String(arc4random())
    
    review.locale = "en_US"
    review.sendEmailAlertWhenCommented = true
    review.sendEmailAlertWhenPublished = true
    review.userNickname = "UserNickname" + randomId
    //review.user = "userField" + randomId
    review.userId = "userField" + randomId
    review.netPromoterScore = 5
    review.userEmail = "developer@bazaarvoice.com"
    review.agreedToTermsAndConditions = true
    review.action = .preview
    
    review.addContextDataValueBool("VerifiedPurchaser", value: false)
    review.addContextDataValueString("Age", value: "18to24")
    review.addContextDataValueString("Gender", value: "Male")
    review.addRatingQuestion("Cleanliness", value: 1)
    review.addRatingQuestion("HelpfullNess", value: 3)
    review.addRatingQuestion("Inventory", value: 4)
    
    return review
  }
  
  
  func testSubmitReviewFailureStore() {
    let expectation = self.expectation(description: "testSubmitReviewFailureStore")
    
    let review = BVStoreReviewSubmission(reviewTitle: "", reviewText: "", rating: 123, storeId: "1000001")
    review.userNickname = "cgil"
    review.userId = "craiggiddl"
    review.action = .submit
    
    review.submit({ (reviewSubmission) in
      //XCTFail()
      expectation.fulfill()
    }, failure: { (errors) in
      errors.forEach { print("Expected Failure Item: \($0)") }
      XCTAssertEqual(errors.count, 5)
      expectation.fulfill()
    })
    waitForExpectations(timeout: 10, handler: nil)
  }
  
}
