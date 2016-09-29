//
//  ConversationsSubmissionTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK

class QuestionSubmissionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        BVSDKManager.sharedManager().clientId = "apitestcustomer"
        BVSDKManager.sharedManager().apiKeyConversations = "KEY_REMOVED"
        BVSDKManager.sharedManager().staging = true
    }
    
    func testSubmitQuestionWithPhoto() {
        let expectation = expectationWithDescription("")
        
        let question = self.fillOutQuestion(.Submit)
        question.submit({ (questionSubmission) in
            expectation.fulfill()
            XCTAssertTrue(questionSubmission.formFields?.keys.count == 0)
        }, failure: { (errors) in
            XCTFail()
        })
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testPreviewQuestionWithPhoto() {
        let expectation = expectationWithDescription("")
        
        let question = self.fillOutQuestion(.Preview)
        question.submit({ (questionSubmission) in
            expectation.fulfill()
            // When run in Preview mode, we get the formFields that can be used for submission.
            XCTAssertTrue(questionSubmission.formFields?.keys.count == 33)
            }, failure: { (errors) in
                XCTFail()
        })
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    
    func fillOutQuestion(action : BVSubmissionAction) -> BVQuestionSubmission {
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
        
        question.addPhoto(PhotoUploadTests.createImage(), withPhotoCaption: "Yo dawg")
        
        return question
    }
    
    func testSubmitQuestionFailure() {
        let expectation = expectationWithDescription("")
        
        let question = BVQuestionSubmission(productId: "1000001")
        question.userNickname = "cgil"
        question.userId = "craiggiddl"
        question.action = .Preview
        
        question.submit({ (questionSubmission) in
            XCTFail()
        }, failure: { (errors) in
            
            XCTAssertEqual(errors.count, 2)
            for error in errors {
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
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
}
