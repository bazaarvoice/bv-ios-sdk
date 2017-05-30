//
//  CommentSubmissionTests.swift
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class CommentSubmissionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        super.setUp()
        let configDict = ["clientId": "conciergeapidocumentation",
                          "apiKeyConversations": "caB45h2jBqXFw1OE043qoMBD1gJC8EwFNCjktzgwncXY4"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.error)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSubmitReviewComment() {
        
        let expectation = self.expectation(description: "testSubmitReviewComment")
        
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
        
//        if let image = PhotoUploadTests.createImage() {
//            commentRequest.addPhoto(image, withPhotoCaption: "Yo dawg")
//        }
        
        commentRequest.submit({ (commentSubmission) in
            
            XCTAssertTrue(commentSubmission.formFields?.keys.count == 11)
            XCTAssertTrue(commentSubmission.comment?.title == commentTitle)
            XCTAssertTrue(commentSubmission.comment?.commentText == commentText)
            XCTAssertNil(commentSubmission.submissionId)
            XCTAssertNotNil(commentSubmission.comment?.submissionTime)
            XCTAssertTrue(commentSubmission.locale == "en_US")
            
            expectation.fulfill()
            
        }, failure: { (errors) in
            expectation.fulfill()
            XCTFail()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
        
        
    }
    
    func testSumbitCommentWithError() {
        
        let expectation = self.expectation(description: "testSubmitReviewComment")
        
        let commentText = "short text"
        let commentRequest = BVCommentSubmission(reviewId: "12345", withCommentText: commentText)
        commentRequest.action = .preview
        
        commentRequest.submit({ (commentSubmission) in
            
            XCTFail("Should not hit success block")
            expectation.fulfill()
            
        }, failure: { (errors) in
            
            let firstError = errors.first! as NSError
            XCTAssertNotNil(firstError.localizedDescription.range(of: "ERROR_PARAM_MISSING_USER_ID"))
            expectation.fulfill()
           
        })
        
        waitForExpectations(timeout: 10, handler: nil)
        
    }
    
}
