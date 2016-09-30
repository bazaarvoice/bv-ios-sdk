//
//  AnswerSubmissionTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK

class AnswerSubmissionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        BVSDKManager.sharedManager().clientId = "apitestcustomer"
        BVSDKManager.sharedManager().apiKeyConversations = "2cpdrhohmgmwfz8vqyo48f52g"
        BVSDKManager.sharedManager().staging = true
        
    }
    
    func testSubmitAnswerWithPhoto() {
        let expectation = expectationWithDescription("")
        
        let answer = self.fillOutAnswer(.Submit)
        answer.submit({ (answerSubmission) in
            expectation.fulfill()
             XCTAssertTrue(answerSubmission.formFields?.keys.count == 0)
        }, failure: { (errors) in
            expectation.fulfill()
            XCTFail()
        })
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testPreviewAnswerWithPhoto() {
        let expectation = expectationWithDescription("")
        let answer = self.fillOutAnswer(.Preview)
        answer.submit({ (answerSubmission) in
            expectation.fulfill()
            XCTAssertTrue(answerSubmission.formFields?.keys.count == 22)
        }, failure: { (errors) in
            expectation.fulfill()
            XCTFail()
        })
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func fillOutAnswer(action : BVSubmissionAction) -> BVAnswerSubmission {
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
        
        answer.addPhoto(PhotoUploadTests.createImage(), withPhotoCaption: "Yo dawg")
        
        return answer
    }
    
    func testSubmitAnswerFailure() {
        let expectation = expectationWithDescription("")
        
        let answer = BVAnswerSubmission(questionId: "6104", answerText: "")
        answer.userId = "craiggil"
        answer.action = .Preview
        
        answer.submit({ (questionSubmission) in
            XCTFail()
        }, failure: { (errors) in
            
            XCTAssertEqual(errors.count, 2)
            for error in errors {
                let fieldName = error.userInfo[BVFieldErrorName] as! String
                let errorCode = error.userInfo[BVFieldErrorCode] as! String
                let errorMessage = error.userInfo[BVFieldErrorMessage] as! String
                
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
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
}
