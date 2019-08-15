//
//  BVInitiateSubmitTest.swift
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSDK

class BVInitiateSubmitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let configDict = ["clientId": "testcustomermobilesdk",
                          "apiKeyConversations": "KEY_REMOVED"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.verbose)
    }

    func testInitiateSubmitWithUserID() {
        let expectation = self.expectation(description: "testInitiateSubmitWithUserID")
        let initiateSubmitRequest = BVInitiateSubmitRequest(productIds: ["product1", "product2", "product3"])
        initiateSubmitRequest.userId = "test109"
        initiateSubmitRequest.locale = "en_US"
        initiateSubmitRequest.submit({ (initiateSubmitResponseData) in
            let products = initiateSubmitResponseData.result?.products
            let formData = products?.values.first as? BVInitiateSubmitFormData
            let review =  formData?.progressiveSubmissionReview
            
            expectation.fulfill()
            XCTAssertTrue( products?.count == 3)
            XCTAssertTrue( formData?.submissionSessionToken != nil)
            XCTAssertTrue( formData?.fieldsOrder != nil)
            XCTAssertTrue( formData?.formFields != nil)
            XCTAssertTrue( review?.submissionId != nil)
            XCTAssertTrue( review?.submissionTime != nil)
            XCTAssertTrue( review?.productId != nil)
        }, failure: { (errors) in
            expectation.fulfill()
            print(errors)
            XCTFail()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInitiateSubmitWithExtendedResponse() {
        let expectation = self.expectation(description: "testInitiateSubmitWithUserID")
        let initiateSubmitRequest = BVInitiateSubmitRequest(productIds: ["product1", "product2", "product3"])
        initiateSubmitRequest.userId = "test109"
        initiateSubmitRequest.locale = "en_US"
        
        initiateSubmitRequest.submit({ (initiateSubmitResponseData) in
            guard let defaultResponse = initiateSubmitResponseData.result?.products.values.first as? BVInitiateSubmitFormData else {return}
            guard let defaultFields = defaultResponse.formFields else {return}
            initiateSubmitRequest.extendedResponse = true
            
            initiateSubmitRequest.submit({ (initiateSubmitResponseExtendedData) in
                guard let extenedResponse = initiateSubmitResponseExtendedData.result?.products.values.first as? BVInitiateSubmitFormData else {return}
                guard let extendedFields = extenedResponse.formFields else {return}
                    expectation.fulfill()
                    XCTAssertTrue(extendedFields.count > defaultFields.count)
                }, failure: { (errors) in
                    expectation.fulfill()
                    print(errors)
                    XCTFail()
                })
        }, failure: { (errors) in
            expectation.fulfill()
            print(errors)
            XCTFail()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInitiateSubmitWithUserToken() {
        let expectation = self.expectation(description: "testInitiateSubmitWithUserToken")
        let initiateSubmitRequest = BVInitiateSubmitRequest(productIds: ["product1", "product2", "product3"])
        initiateSubmitRequest.userToken = "TOKEN_REMOVED"
        initiateSubmitRequest.locale = "en_US"
        initiateSubmitRequest.extendedResponse = true;
        
        initiateSubmitRequest.submit({ (initiateSubmitResponseData) in
            expectation.fulfill()
            XCTAssertTrue( initiateSubmitResponseData.result?.products.count == 3)
        }, failure: { (errors) in
            expectation.fulfill()
            print(errors)
            XCTFail()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInitiateSubmitMissingUserIdError() {
        let expectation = self.expectation(description: "testInitiateSubmitMissingUserIdError")
        let initiateSubmitRequest = BVInitiateSubmitRequest(productIds: ["product1", "product2", "product3"])
        initiateSubmitRequest.locale = "en_US"

        initiateSubmitRequest.submit({ (initiateSubmitResponseData) in
            expectation.fulfill()
            XCTFail()
        }, failure: { (errors) in
            expectation.fulfill()
            XCTAssertTrue( errors.count == 1)
            XCTAssertTrue( errors.first!.localizedDescription == "Bad Request: UserId is missing/invalid")
            print(errors)
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInitiateSubmitInvalidApiKeyError() {
        
        let invalidConfigDict = ["clientId": "testcustomermobilesdk",
                                 "apiKeyConversations": ""];
        BVSDKManager.configure(withConfiguration: invalidConfigDict, configType: .staging)
        
        let expectation = self.expectation(description: "testInitiateSubmitInvalidApiKeyError")
        let initiateSubmitRequest = BVInitiateSubmitRequest(productIds: ["product1", "product2", "product3"])
        initiateSubmitRequest.userId = "test109"
        initiateSubmitRequest.locale = "en_US"

        initiateSubmitRequest.submit({ (initiateSubmitResponseData) in
            expectation.fulfill()
            XCTFail()
        }, failure: { (errors) in
            expectation.fulfill()
            XCTAssertTrue( errors.count == 1)
            XCTAssertTrue( errors.first!.localizedDescription == "ERROR_PARAM_INVALID_API_KEY: The passKey provided is invalid.")
            print(errors)
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInitiateSubmitMissingProductsError() {
        let expectation = self.expectation(description: "testInitiateSubmitMissingProductsError")
        
        let initiateSubmitRequest = BVInitiateSubmitRequest(productIds: [])
        initiateSubmitRequest.userId = "test109"
        initiateSubmitRequest.locale = "en_US"

        initiateSubmitRequest.submit({ (initiateSubmitResponseData) in
            expectation.fulfill()
            XCTFail()
        }, failure: { (errors) in
            expectation.fulfill()
            XCTAssertTrue( errors.count == 1)
            XCTAssertTrue( errors.first!.localizedDescription == "Bad Request: Need at least one Product Id")
            print(errors)
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInitiateSubmitMissingLocaleError() {
        let expectation = self.expectation(description: "testInitiateSubmitMissingLocaleError")
        
        let initiateSubmitRequest = BVInitiateSubmitRequest(productIds: ["product1", "product2", "product3"])
        initiateSubmitRequest.userId = "test109"
        
        initiateSubmitRequest.submit({ (initiateSubmitResponseData) in
            expectation.fulfill()
            XCTFail()
        }, failure: { (errors) in
            expectation.fulfill()
            XCTAssertTrue( errors.count == 1)
            XCTAssertTrue( errors.first!.localizedDescription == "Bad Request: Locale is missing")
            print(errors)
        })
        waitForExpectations(timeout: 10, handler: nil)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
