//
//  ConversationsSubmissionTests.swift
//  BVSDKTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK

class QuestionSubmissionTests: BVBaseStubTestCase {
  
  override func setUp() {
    super.setUp()
    
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": "2cpdrhohmgmwfz8vqyo48f52g"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
  }
  
  func testSubmitQuestionWithPhoto() {
    let expectation = self.expectation(description: "")
    
    let sequenceFiles:[String] =
      [
        "testSubmitQuestionWithPhotoPreview.json",
        "testUploadablePhotoPNGSuccess.json",
        "testSubmitQuestionWithPhotoSubmit.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let question = self.fillOutQuestion(.submit)
    question.submit({ (questionSubmission) in
      expectation.fulfill()
      XCTAssertTrue(questionSubmission.formFields?.keys.count == 0)
    }, failure: { (errors) in
      XCTFail()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSubmitQuestionWithPhotoPreview() {
    let expectation = self.expectation(description: "")
    
    let sequenceFiles:[String] =
      [
        "testSubmitQuestionWithPhotoPreview.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let question = self.fillOutQuestion(.preview)
    question.submit({ (questionSubmission) in
      expectation.fulfill()
      // When run in Preview mode, we get the formFields that can be used for submission.
      XCTAssertTrue(questionSubmission.formFields?.keys.count == 33)
    }, failure: { (errors) in
      XCTFail()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSubmitQuestionFailure() {
    let expectation = self.expectation(description: "")
    
    let sequenceFiles:[String] =
      [
        "testSubmitQuestionFailure.json"
    ]
    stub(withJSONSequence: sequenceFiles)
    
    let question = BVQuestionSubmission(productId: "1000001")
    question.userNickname = "cgil"
    question.userId = "craiggiddl"
    question.action = .preview
    
    question.submit({ (questionSubmission) in
      XCTFail()
    }, failure: { (errors) in
      
      XCTAssertEqual(errors.count, 1)
      for error in errors as [NSError] {
        let fieldName = error.userInfo[BVFieldErrorName] as! String
        let errorCode = error.userInfo[BVFieldErrorCode] as! String
        let errorMessage = error.userInfo[BVFieldErrorMessage] as! String
        
        if fieldName == "questionsummary" {
          XCTAssertEqual(errorCode, "ERROR_FORM_REQUIRED")
          XCTAssertEqual(errorMessage, "You must enter a question.")
        }
        else {
          XCTAssertEqual(fieldName, "usernickname")
          XCTAssertEqual(errorCode, "ERROR_FORM_DUPLICATE")
          XCTAssertEqual(errorMessage, "Someone has already used that nickname.")
        }
      }
      
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func fillOutQuestion(_ action : BVSubmissionAction) -> BVQuestionSubmission {
    let question = BVQuestionSubmission(productId: "test1")
    let randomId = String(arc4random())
    
    question.questionSummary = "Question title question title?"
    question.questionDetails = "Question body Question body Question body Question body Question body Question body Question body"
    question.campaignId = "BV_REVIEW_DISPLAY"
    question.locale = "en_US"
    question.sendEmailAlertWhenAnswered = true
    question.sendEmailAlertWhenPublished = true
    question.userNickname = "UserNickname" + randomId
    question.userId = "UserId" + randomId
    question.userEmail = "developer@bazaarvoice.com"
    question.agreedToTermsAndConditions = true
    question.action = action
    if let image = PhotoUploadTests.createPNG() {
      question.addPhoto(image, withPhotoCaption: "Very photogenic")
    }
    return question
  }
  
}
