//
//  ConversationsSubmissionTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK

class ReviewSubmissionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let configDict = ["clientId": "apitestcustomer",
                          "apiKeyConversations": "KEY_REMOVED"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.error)
    }
    
    func testSubmitReviewWithPhoto() {
        let expectation = self.expectation(description: "testSubmitReviewWithPhoto")
        
        let review = self.fillOutReview(.submit)
        review.submit({ (reviewSubmission) in
            XCTAssertTrue(reviewSubmission.formFields?.keys.count == 0)
            expectation.fulfill()
        }, failure: { (errors) in
            print(errors.description)
            for error in errors {
                guard let nsError = error as? NSError else { continue }
                print(nsError.userInfo["BVFieldErrorMessage"])
            }
            XCTFail()
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testPreviewReviewWithPhoto() {
        
        let expectation = self.expectation(description: "testPreviewReviewWithPhoto")
        
        let review = self.fillOutReview(.preview)
        
        review.submit({ (reviewSubmission) in
                // When run in Preview mode, we get the formFields that can be used for submission.
                XCTAssertTrue(reviewSubmission.formFields?.keys.count == 50)
                expectation.fulfill()
            }, failure: { (errors) in
                XCTFail()
                expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    let VIDEO_URL = "https://www.youtube.com/watch?v=oHg5SJYRHA0"
    let VIDEO_CAPTION = "Very videogenic"
    
    func testPreviewReviewWithVideo() {
        
        let expectation = self.expectation(description: "testPreviewReviewWithVideo")
        
        let review = self.fillOutReview(.preview)
        review.addVideoURL(VIDEO_URL, withCaption: VIDEO_CAPTION)
        review.submit({ (reviewSubmission) in
            // When run in Preview mode, we get the formFields that can be used for submission.
            
            XCTAssertTrue(reviewSubmission.formFields?.keys.count == 50)
            expectation.fulfill()
        }, failure: { (errors) in
            XCTFail()
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func fillOutReview(_ action : BVSubmissionAction) -> BVReviewSubmission {
        let review = BVReviewSubmission(reviewTitle: "review title",
                                      reviewText: "more than 50 more than 50 more than 50 more than 50 more than 50",
                                      rating: 4,
                                      productId: "test1")
        
        let randomId = String(arc4random())
        
        review.campaignId = "BV_REVIEW_DISPLAY"
        review.locale = "en_US"
        review.sendEmailAlertWhenCommented = true
        review.sendEmailAlertWhenPublished = true
        review.userNickname = "UserNickname" + randomId
        review.netPromoterScore = 5
        review.netPromoterComment = "Never!"
        review.userId = "UserId" + randomId
        review.userEmail = "developer@bazaarvoice.com"
        review.agreedToTermsAndConditions = true
        review.action = action
        
        review.addContextDataValueBool("VerifiedPurchaser", value: false)
        review.addContextDataValueString("Age", value: "18to24")
        review.addContextDataValueString("Gender", value: "Male")
        review.addRatingQuestion("Quality", value: 1)
        review.addRatingQuestion("Value", value: 3)
        review.addRatingQuestion("HowDoes", value: 4)
        review.addRatingQuestion("Fit", value: 3)
        review.addCustomSubmissionParameter("_foo", withValue: "bar")
        
        if let image = PhotoUploadTests.createPNG() {
            review.addPhoto(image, withPhotoCaption: "Very photogenic")
        }
        
        return review
    }
    
    
    func testSubmitReviewFailure() {
        let expectation = self.expectation(description: "testSubmitReviewFailure")
        
        let review = BVReviewSubmission(reviewTitle: "", reviewText: "", rating: 123, productId: "1000001")
        review.userNickname = "cgil"
        review.userId = "craiggiddl"
        review.action = .submit
        
        review.submit({ (reviewSubmission) in
            XCTFail()
            expectation.fulfill()
        }, failure: { (errors) in
            errors.forEach { print("Expected Failure Item: \($0)") }
            
            XCTAssertEqual(errors.count, 5)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSubmitReviewFailureFormCodeParsing() {
        let expectation = self.expectation(description: "testSubmitReviewFailure")
        
        let review = BVReviewSubmission(reviewTitle: "", reviewText: "", rating: 123, productId: "1000001")
        review.userNickname = "cgil"
        review.userId = "craiggiddl"
        review.action = .submit
        
        review.submit({ (reviewSubmission) in
            XCTFail()
            expectation.fulfill()
        }, failure: { (errors) in
            var formRequiredCount = 0
            var formDuplicateCount = 0
            var formTooHighCount = 0
            errors.forEach { error in
                let nsError = error as NSError
                let errorCodeString = nsError.userInfo[BVFieldErrorCode] as? String
                print("Error code string: \(errorCodeString ?? "empty")")
                let bvSubmissionErrorCode = nsError.bvSubmissionErrorCode()
                switch (bvSubmissionErrorCode) {
                case .formRequired:
                    print("form required enum found")
                    formRequiredCount = formRequiredCount + 1
                case .formDuplicate:
                    print("form duplicate enum found")
                    formDuplicateCount = formDuplicateCount + 1
                case .formTooHigh:
                    print("form too high enum found")
                    formTooHighCount = formTooHighCount + 1
                default:
                    print("unknown enum")
                }
            }
            
            XCTAssertEqual(formRequiredCount, 3)
            XCTAssertEqual(formDuplicateCount, 1)
            XCTAssertEqual(formTooHighCount, 1)
            
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSubmitReviewFailureCodeParsing() {
        let expectation = self.expectation(description: "testSubmitReviewFailure")
        
        let review = BVReviewSubmission(reviewTitle: "", reviewText: "", rating: 123, productId: "")
        review.userNickname = "cgil"
        review.userId = "craiggiddl"
        review.action = .submit
        
        review.submit({ (reviewSubmission) in
            XCTFail()
            expectation.fulfill()
        }, failure: { (errors) in
            var badRequestCount = 0
            errors.forEach { error in
                let nsError = error as NSError
                let bvErrorCode = nsError.bvErrorCode()
                switch (bvErrorCode) {
                case .badRequest:
                    print("Found bad request")
                    badRequestCount = badRequestCount + 1
                default:
                    print("unknown enum found")
                }
            }
            
            XCTAssertEqual(badRequestCount, 1)
            
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
}
