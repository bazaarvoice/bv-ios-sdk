//
//  FeedbackSubmissionTests.swift
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class FeedbackSubmissionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        BVSDKManager.shared().clientId = "apitestcustomer"
        BVSDKManager.shared().apiKeyConversations = "2cpdrhohmgmwfz8vqyo48f52g"
        BVSDKManager.shared().staging = true
        BVSDKManager.shared().setLogLevel(.error)
        
    }
    
    func testSubmitFeedbackHelpfulness() {
        
        let expectation = self.expectation(description: "testSubmitFeedbackHelpfulness")
        
        let feedback = BVFeedbackSubmission(contentId: "83725", withConentType: .review, with: .helpfulness)
        
        let randomId = String(arc4random())
        
        feedback.userId = "userId" + randomId
        feedback.vote = .positive
        feedback.action = .preview // don't submit for real

        feedback.submit({ (response) in
                // success
                // verify response object....
                XCTAssertNotNil(response.feedback)
                XCTAssertTrue(response.feedback?.inappropriateResponse == nil)
                XCTAssertEqual(response.feedback?.helpfulnessResponse.authorId, feedback.userId)
                XCTAssertEqual(response.feedback?.helpfulnessResponse.vote, "POSITIVE")
            
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
        
        let feedback = BVFeedbackSubmission(contentId: "83725", withConentType: .review, with: .inappropriate)
        
        let randomId = String(arc4random())
        
        feedback.userId = "userId" + randomId
        feedback.action = .preview
        feedback.reasonText = "Optional reason text in this field."
        
        feedback.submit({ (response) in
            // success
            // verify response object...
            XCTAssertNotNil(response.feedback)
            XCTAssertTrue(response.feedback?.helpfulnessResponse == nil)
            XCTAssertEqual(response.feedback?.inappropriateResponse.authorId, feedback.userId)
            XCTAssertEqual(response.feedback?.inappropriateResponse.reasonText, feedback.reasonText)
            expectation.fulfill()
            
        }) { (errors) in
            // error
            XCTFail("Should not be in failure block")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    
    func testSubmissionFailure() {
        
        let expectation = self.expectation(description: "testSubmitFeedbackFlag")
        
        let feedback = BVFeedbackSubmission(contentId: "badidshouldmakeerror", withConentType: .review, with: .inappropriate)
        
        let randomId = String(arc4random())
        
        feedback.userId = "userId" + randomId
        feedback.action = .preview
        
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
