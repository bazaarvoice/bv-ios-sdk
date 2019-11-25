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
        waitForExpectations(timeout: 350, handler: nil)
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
    
    func testIncompleteProgressiveSubmitRequestWithPreview() {
        let expectation = self.expectation(description: "testIncompleteProgressiveSubmitRequestWithPreview")
        let submission = self.buildRequest()
        submission.submissionFields["reviewText"] = nil
        submission.isPreview = true
        
        submission.submit({ (submittedReview) in
            let result = submittedReview.result
            let review = result?.review
            
            XCTAssertTrue(result?.submissionSessionToken != nil)
            XCTAssertTrue(result?.submissionId == nil)
            XCTAssertTrue(result?.isFormComplete == false)
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
            "title" : " my favorite product ever!",
            "reviewText" : "This is great its so awesome. I highly recomend using this product and think it makes a great gift for any holiday or special occasion. by far the best purchase ive made this year",
            "agreedtotermsandconditions" : agreedtotermsandconditions
        ]
        let submission = BVProgressiveSubmitRequest(productId:"product4")
        submission.submissionSessionToken = "u8q3udgd48olv917egq20k50b_ec59b3be048c7df97bf438b057209d349d60645f4bea79c375551fa29b60ea55_5K9B1iWK8SY="
        submission.locale = "en_US"
        submission.userToken = "d8dd0efd2f9e2ebc5d201b3f2343fa06f8a3d4ff6259c44df02622ba8e0506e66d61786167653d333026484f535445443d564552494649454426646174653d323031393130323526656d61696c616464726573733d4256406d61696c2e636f6d267573657269643d74657374313039"
        submission.submissionFields = fields as! [AnyHashable : Any]
        return submission
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
