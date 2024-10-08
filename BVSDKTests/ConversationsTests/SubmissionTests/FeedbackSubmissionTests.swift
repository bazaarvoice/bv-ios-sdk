//
//  FeedbackSubmissionTests.swift
//  BVSDKTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class FeedbackSubmissionTests: BVBaseStubTestCase {
  
    private enum SubmissionPreference {
        case requireEncryptedUserIDs
        case plainTextAndEncryptedUserIDs
        
        var passKey: String {
            switch self {
            
            case .requireEncryptedUserIDs:
                return "caxi5FUl5PNoMOzk2EQmcc6lmYGpHp5tK2CHpcKUWxVXk" // passkey with require encrypted user ids set to true
            
            case .plainTextAndEncryptedUserIDs:
                return "ca4Fx0KXNpwZQTkNiyfRsJ5P1RO0oGiTuo8bSmcBVBm6E" // passkey with require encrypted user ids set to false
            }
        }
    }
    
  override func setUp() {
    super.setUp()
    
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey11)];
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
    feedback.userId = BVTestUsers().loadValueForKey(key: .feedbackUserId)
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
      feedback.userId = BVTestUsers().loadValueForKey(key: .feedbackUserId)
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
    
    func testSubmitFeedbackWithUserId() {
        
        self.updateConfiguration(submissionPreference: .plainTextAndEncryptedUserIDs)
        
        let expectation = self.expectation(description: "testSubmitFeedbackWithUserId")
        
        let feedback = BVFeedbackSubmission(contentId: "83725", with: .review, with: .helpfulness)
        feedback.userId = BVTestUsers().loadValueForKey(key: .feedbackUserId)
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
    
    func testSubmitFeedbackWithUAS() {
        self.updateConfiguration(submissionPreference: .plainTextAndEncryptedUserIDs)
        
        let expectation = self.expectation(description: "testSubmitFeedbackWithUAS")
        
        let feedback = BVFeedbackSubmission(contentId: "83725", with: .review, with: .helpfulness)
        feedback.vote = .positive
        feedback.user = BVTestUsers().loadValueForKey(key: .feedbackUser)
        
        feedback.submit({ (response) in
          // success
          // verify response object....
          XCTAssertNotNil(response.result)
          let inappropriateResponse = response.result?.inappropriateResponse
          XCTAssertNil(inappropriateResponse)
          XCTAssertEqual(response.result?.helpfulnessResponse.vote, "POSITIVE")
          
          expectation.fulfill()
          
        }) { (errors) in
          // error
          XCTFail("Should not be in failure block")
          expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSubmitFeedbackWithUserIdForRequireEncryptedUserIds() {
        
        self.updateConfiguration(submissionPreference: .requireEncryptedUserIDs)
        
        let expectation = self.expectation(description: "testSubmitFeedbackWithUASForRequireEncryptedUserIds")
        
        let feedback = BVFeedbackSubmission(contentId: "83725", with: .review, with: .helpfulness)
        feedback.userId = BVTestUsers().loadValueForKey(key: .feedbackUserId)
        feedback.vote = .positive
        
        feedback.submit({ (response) in
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
    
    func testSubmitFeedbackWithUASForRequireEncryptedUserIds() {
        
        self.updateConfiguration(submissionPreference: .requireEncryptedUserIDs)
        
        let expectation = self.expectation(description: "testSubmitFeedbackWithUserIdForRequireEncryptedUserIds")
        
        let feedback = BVFeedbackSubmission(contentId: "83725", with: .review, with: .helpfulness)
        feedback.vote = .positive
        feedback.user = BVTestUsers().loadValueForKey(key: .feedbackUser)
        
        feedback.submit({ (response) in
          // success
          // verify response object....
          XCTAssertNotNil(response.result)
          let inappropriateResponse = response.result?.inappropriateResponse
          XCTAssertNil(inappropriateResponse)
          XCTAssertEqual(response.result?.helpfulnessResponse.vote, "POSITIVE")
          
          expectation.fulfill()
          
        }) { (errors) in
          // error
          XCTFail("Should not be in failure block")
          expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    private func updateConfiguration(submissionPreference: SubmissionPreference) {
        let configDict = ["clientId": "apitestcustomer",
                          "apiKeyConversations": submissionPreference.passKey];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.error)
    }
}
