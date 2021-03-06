//
//  BVProgressiveSubmitTest.swift
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSDK

class BVProgressiveSubmitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let configDict = ["clientId": "testcustomermobilesdk",
                          "apiKeyConversations": "cauPFGiXDMZYw1QQ11PBmJXt5YdK5oEvirFBMxlyshhlU"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.verbose)
    }
    
    func testProgressiveSubmitRequestWithUserToken() {
        let expectation = self.expectation(description: "testProgressiveSubmitRequestWithUserToken")
        let submission = self.buildRequest()
        
        
        submission.submit({ (submittedReview) in
            let result = submittedReview.result
            let review = result?.review
            
            XCTAssertTrue(result?.submissionSessionToken != nil)
            XCTAssertTrue(result?.submissionId != nil)
            XCTAssertTrue(result?.isFormComplete == true)
            XCTAssertTrue(review?.rating == (submission.submissionFields["rating"] as? NSNumber))
            XCTAssertTrue(review?.title == (submission.submissionFields["title"] as? String))
            XCTAssertTrue(review?.reviewText == (submission.submissionFields["reviewText"] as? String))
            expectation.fulfill()
        }, failure: { (errors) in
            expectation.fulfill()
            print(errors)
            XCTFail()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testProgressiveSubmitRequestWithFormFields() {
        let expectation = self.expectation(description: "testProgressiveSubmitRequestWithUserToken")
        let submission = self.buildRequest()
        submission.includeFields = true
        
        submission.submit({ (submittedReview) in
            let result = submittedReview.result
            let review = result?.review
            
            XCTAssertTrue(result?.submissionSessionToken != nil)
            XCTAssertTrue(result?.submissionId != nil)
            XCTAssertTrue(result?.fieldsOrder != nil)
            XCTAssertTrue(result?.formFields != nil)
            XCTAssertTrue(review?.rating == (submission.submissionFields["rating"] as? NSNumber))
            XCTAssertTrue(review?.title == (submission.submissionFields["title"] as? String))
            XCTAssertTrue(review?.reviewText == (submission.submissionFields["reviewText"] as? String))
            expectation.fulfill()
        }, failure: { (errors) in
            expectation.fulfill()
            print(errors)
            XCTFail()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testProgressiveSubmitRequestWithPreview() {
        let expectation = self.expectation(description: "testProgressiveSubmitRequestWithUserToken")
        let submission = self.buildRequest()
        submission.isPreview = true
        
        submission.submit({ (submittedReview) in
            let result = submittedReview.result
            let review = result?.review
            
            XCTAssertTrue(result?.submissionSessionToken != nil)
            XCTAssertTrue(result?.submissionId == nil)
            XCTAssertTrue(review?.rating == (submission.submissionFields["rating"] as? NSNumber))
            XCTAssertTrue(review?.title == (submission.submissionFields["title"] as? String))
            XCTAssertTrue(review?.reviewText == (submission.submissionFields["reviewText"] as? String))
            expectation.fulfill()
        }, failure: { (errors) in
            expectation.fulfill()
            print(errors)
            XCTFail()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testProgressiveSubmitMissingUserEmailError() {
        let expectation = self.expectation(description: "testProgressiveSubmitMissingUserEmailError")
        let submission = self.buildRequest()
        submission.userToken = nil
        submission.userId = "tets109"
        
        submission.submit({ (submittedReview) in
            expectation.fulfill()
            XCTFail()
        }, failure: { (errors) in
            XCTAssertTrue( errors.count == 1)
            XCTAssertTrue( errors.first!.localizedDescription == "Bad Request: Email address is missing/invalid")
            expectation.fulfill()
            print(errors)
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testProgressiveSubmitMissingUserIdError() {
        let expectation = self.expectation(description: "testProgressiveSubmitMissingUserIdError")
        let submission = self.buildRequest()
        submission.userToken = nil
        
        submission.submit({ (submittedReview) in
            expectation.fulfill()
            XCTFail()
        }, failure: { (errors) in
            
            XCTAssertTrue( errors.count == 1)
            XCTAssertTrue( errors.first!.localizedDescription == "Bad Request: UserId is missing/invalid")
            expectation.fulfill()
            print(errors)
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testProgressiveSubmitMissingProductId() {
        let expectation = self.expectation(description: "testProgressiveSubmitMissingProductId")
        let submission = self.buildRequest()
        submission.productId = ""
        
        submission.submit({ (submittedReview) in
            expectation.fulfill()
            XCTFail()
        }, failure: { (errors) in
            XCTAssertTrue( errors.count == 1)
            XCTAssertTrue( errors.first!.localizedDescription == "Bad Request: ProductId is missing")
            expectation.fulfill()
            print(errors)
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testProgressiveSubmitInvalidFormField() {
        let expectation = self.expectation(description: "testProgressiveSubmitInvalidFormField")
        let submission = self.buildRequest()
        submission.submissionFields["reviewText"] = "Great product"
        
        submission.submit({ (submittedReview) in
            expectation.fulfill()
            XCTFail()
        }, failure: { (errors) in
            XCTAssertTrue( errors.count == 1)
            XCTAssertTrue( errors.first!.localizedDescription == "reviewtext: ERROR_FORM_TOO_SHORT: too short")
            expectation.fulfill()
            print(errors)
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testProgressiveSubmitInvalidPasskey() {
        let expectation = self.expectation(description: "testProgressiveSubmitInvalidPasskey")
        let configDict = ["clientId": "testcustomermobilesdk",
                          "apiKeyConversations": ""];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        
        let submission = self.buildRequest()
        
        submission.submit({ (submittedReview) in
            expectation.fulfill()
            XCTFail()
        }, failure: { (errors) in
            XCTAssertTrue( errors.count == 1)
            XCTAssertTrue( errors.first!.localizedDescription == "ERROR_PARAM_INVALID_API_KEY: The passKey provided is invalid.")
            expectation.fulfill()
            print(errors)
            
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func buildRequest() -> BVProgressiveSubmitRequest {
        let agreedtotermsandconditions = true
        let fields: NSDictionary = [
            "rating" : 4,
            "title" : "my favorite product ever!",
            "reviewText" : "This is great its so awesome. I highly recomend using this product and think it makes a great gift for any holiday or special occasion. by far the best purchase ive made this year",
            "agreedtotermsandconditions" : agreedtotermsandconditions
        ]
        let submission = BVProgressiveSubmitRequest(productId:"product10")
        submission.submissionSessionToken = "Nhe9yRdZuUFPWqJ8vAwAAJffmL20qOorqf0J87lcklmt8GZ7tbNDDyDx/UZeV+Dv7CgRurvxkrn0uAiNjdQpq9Z2ABxVvNq/kHnElA3GTs0="
        submission.locale = "en_US"
        submission.userToken = "d45025df4135ef2689ff580dd4208f33646174653d3230323030373331267573657269643d7465737431303926456d61696c416464726573733d425625343061696c2e636f6d264d61786167653d3335362656657269666965645075726368617365723d74727565"
        submission.submissionFields = fields as! [AnyHashable : Any]
        return submission
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
