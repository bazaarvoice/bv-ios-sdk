//
//  AnswerSubmissionTests.swift
//  BVSDKTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK

class AnswerSubmissionTests: BVBaseStubTestCase {
  
  override func setUp() {
    super.setUp()
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey11)];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    BVSDKManager.shared().setLogLevel(.verbose)
  }
  
  func testSubmitAnswerWithPhoto() {
    let expectation = self.expectation(description: "testSubmitAnswerWithPhoto")
    
    let sequenceFiles:[String] =
      [
        "testSubmitAnswerWithPhotoPreview.json",
        "testUploadPNG.json",
        "testSubmitAnswerWithPhotoSubmit.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let answer = self.fillOutAnswer(.submit)
    answer.submit({ (answerSubmission) in
      expectation.fulfill()
      XCTAssertTrue(answerSubmission.formFields?.keys.count == 0)
    }, failure: { (errors) in
      expectation.fulfill()
      print(errors)
      XCTFail()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testPreviewAnswerWithPhoto() {
    let expectation = self.expectation(description: "testPreviewAnswerWithPhoto")
    
    let sequenceFiles:[String] =
      [
        "testSubmitAnswerWithPhotoPreview.json",
        "testUploadPNG.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let answer = self.fillOutAnswer(.preview)
    answer.submit({ (answerSubmission) in
      expectation.fulfill()
      // When run in Preview mode, we get the formFields that can be used for submission.
      XCTAssertTrue(answerSubmission.formFields?.keys.count == 22)
    }, failure: { (errors) in
      expectation.fulfill()
      XCTFail()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func fillOutAnswer(_ action : BVSubmissionAction) -> BVAnswerSubmission {
    let answerText = "Answer text Answer text Answer text Answer text Answer text Answer text Answer text Answer text"
    let answer = BVAnswerSubmission(questionId: "6104", answerText: answerText)
    
    let randomId = String(arc4random())
    
    answer.campaignId = "BV_REVIEW_DISPLAY"
    answer.locale = "en_US"
    answer.sendEmailAlertWhenPublished = true
    answer.userNickname = "UserNickname" + randomId
    answer.userId = "UserId" + randomId
    answer.userEmail = "developer@bazaarvoice.com"
    answer.agreedToTermsAndConditions = true
    answer.action = action
    
    if let image = PhotoUploadTests.createPNG() {
      answer.addPhoto(image, withPhotoCaption: "Very photogenic")
    }
    
    return answer
  }
  
  func testSubmitAnswerFailure() {
    let expectation = self.expectation(description: "")
    
    let answer = BVAnswerSubmission(questionId: "6104", answerText: "")
      answer.userId = BVTestUsers().loadValueForKey(key: .answerUserId)
    answer.action = .preview
    
    let sequenceFiles:[String] =
      [
        "testSubmitAnswerFailure.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    answer.submit({ (questionSubmission) in
      XCTFail()
    }, failure: { (errors) in
      
      XCTAssertEqual(errors.count, 1)
      for error in errors as [NSError] {
        
        guard let fieldName = error.userInfo[BVFieldErrorName] as? String,
          let errorCode = error.userInfo[BVFieldErrorCode] as? String,
          let errorMessage = error.userInfo[BVFieldErrorMessage] as? String else {
            // Would happen if we get internal server error and/or XML is returned
            XCTFail("Malformed error response")
            break
        }
        
        if fieldName == "answertext" {
          XCTAssertEqual(errorCode, "ERROR_FORM_REQUIRED")
          XCTAssertEqual(errorMessage, "You must enter an answer.")
        }
        else {
          XCTAssertEqual(fieldName, "usernickname")
          XCTAssertEqual(errorCode, "ERROR_FORM_REQUIRED")
          XCTAssertEqual(errorMessage, "You must enter a nickname.")
        }
      }
      
      expectation.fulfill()
    })
    waitForExpectations(timeout: 10, handler: nil)
  }
  
}
