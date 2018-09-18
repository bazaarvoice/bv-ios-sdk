//
//  FeedbackSubmissionTests.swift
//  BVSDKTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class FeedbackSubmissionTests: BVBaseStubTestCase {
  
  override func setUp() {
    super.setUp()
    
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": "KEY_REMOVED"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    BVSDKManager.shared().setLogLevel(.error)
    
  }
  
  func testSubmitFeedbackHelpfulness() {
    
    let expectation = self.expectation(description: "testSubmitFeedbackHelpfulness")
    
    let sequenceFiles:[String] =
      [
        "testSubmitFeedbackHelpfulness.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let feedback = BVFeedbackSubmission(contentId: "83725", with: .review, with: .helpfulness)
    
    feedback.userId = "userId3532791931"
    feedback.vote = .positive
    
    feedback.submit({ (response) in
      // success
      // verify response object....
      XCTAssertNotNil(response.result)
      let inappropriateResponse = response.result?.inappropriateResponse
      XCTAssertNil(inappropriateResponse)
      XCTAssertEqual(response.result?.helpfulnessResponse.authorId, feedback.userId)
      XCTAssertEqual(response.result?.helpfulnessResponse.vote, "POSITIVE")
      
      expectation.fulfill()
      
    }) { (errors) in
      // error
      XCTFail("Should not be in failure block")
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSubmitFeedbackFlag() {
    
    let expectation = self.expectation(description: "testSubmitFeedbackFlag")
    
    let sequenceFiles:[String] =
      [
        "testSubmitFeedbackFlag.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let feedback = BVFeedbackSubmission(contentId: "83725", with: .review, with: .inappropriate)
    
    feedback.userId = "userId1302958052"
    feedback.reasonText = "Optional reason text in this field."
    
    feedback.submit({ (response) in
      // success
      // verify response object...
      XCTAssertNotNil(response.result)
      let helpfulnessResponse = response.result?.helpfulnessResponse
      XCTAssertNil(helpfulnessResponse)
      XCTAssertEqual(response.result?.inappropriateResponse.authorId, feedback.userId)
      XCTAssertEqual(response.result?.inappropriateResponse.reasonText, feedback.reasonText)
      expectation.fulfill()
      
    }) { (errors) in
      // error
      XCTFail("Should not be in failure block")
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  
  func testSubmitFeedbackFailure() {
    
    let expectation = self.expectation(description: "testSubmitFeedbackFlag")
    
    let sequenceFiles:[String] =
      [
        "testSubmitFeedbackFailure.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let feedback = BVFeedbackSubmission(contentId: "badidshouldmakeerror", with: .review, with: .inappropriate)
    
    feedback.userId = "userId" + String(arc4random())
    
    feedback.submit({ (response) in
      // success
      XCTFail("Should not be in success block")
      expectation.fulfill()
    }) { (errors) in
      // error
      let errorString : String = errors[0].localizedDescription;
      XCTAssertEqual(errorString.contains("ERROR_PARAM_INVALID_PARAMETERS"), true)
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 10, handler: nil)
  }
}
