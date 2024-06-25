//
//  CommentSubmissionTests.swift
//  BVSDKTests
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class CommentSubmissionTests: BVBaseStubTestCase {
  
  override func setUp() {
    super.setUp()
    super.setUp()
    let configDict = ["clientId": "conciergeapidocumentation",
                      "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey3)];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    BVSDKManager.shared().setLogLevel(.error)
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testSubmitReviewComment() {
    
    let expectation = self.expectation(description: "testSubmitReviewComment")
    
    let sequenceFiles:[String] =
      [
        "testSubmitReviewComment.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let commentText = "Comment text Comment text Comment text Comment text Comment text Comment text Comment text Comment text"
    let commentTitle = "Comment title"
    let commentRequest = BVCommentSubmission(reviewId: "20134832", withCommentText: commentText)
    commentRequest.action = .preview
    
    let randomId = String(arc4random()) // create a random id for testing only
    
    commentRequest.campaignId = "BV_COMMENT_CAMPAIGN_ID"
    commentRequest.commentTitle = commentTitle
    commentRequest.locale = "en_US"
    commentRequest.sendEmailAlertWhenPublished = true
    commentRequest.userNickname = "UserNickname" + randomId
    commentRequest.userId = "UserId" + randomId
    commentRequest.userEmail = "developer@bazaarvoice.com"
    commentRequest.agreedToTermsAndConditions = true
    
    commentRequest.submit({ (commentSubmission) in
      expectation.fulfill()
      
      guard let submittedComment = commentSubmission.result else {
        XCTFail()
        return
      }
      
      XCTAssertEqual(commentSubmission.formFields?.keys.count, 11)
      XCTAssertEqual(submittedComment.title, commentTitle)
      XCTAssertEqual(submittedComment.commentText, commentText)
      XCTAssertNil(commentSubmission.submissionId)
      XCTAssertNotNil(submittedComment.submissionTime)
      XCTAssertEqual(commentSubmission.locale, "en_US")
      
    }, failure: { (errors) in
      print(errors)
      expectation.fulfill()
      XCTFail()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSumbitReviewCommentWithError() {
    
    let expectation = self.expectation(description: "testSubmitReviewComment")
    
    let sequenceFiles:[String] =
      [
        "testSumbitReviewCommentWithError.json"
    ]
    forceStub(withJSONSequence: sequenceFiles)
    
    let commentText = "short text"
    let commentRequest = BVCommentSubmission(reviewId: "12345", withCommentText: commentText)
    commentRequest.action = .preview
    
    commentRequest.submit({ (commentSubmission) in
      
      XCTFail("Should not hit success block")
      expectation.fulfill()
      
    }, failure: { (errors) in
      
      expectation.fulfill()
      
      guard let firstError = errors.first else {
        print(errors)
        return
      }
      
      print(firstError)
      XCTAssertNotNil(firstError.localizedDescription.range(of: "ERROR_PARAM_MISSING_USER_ID"))
    })
    
    waitForExpectations(timeout: 10, handler: nil)
    
  }
  
}
