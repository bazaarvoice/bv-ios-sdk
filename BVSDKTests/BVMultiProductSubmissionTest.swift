//
//  BVMultiProductSubmissionTest.swift
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSDK

class BVMultiProductSubmissionTest: XCTestCase {

    override func setUp() {
        super.setUp()
        let configDict = ["clientId": "mpr-testcustomer",
                          "apiKeyConversations": "KEY_REMOVED"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.verbose)
    }
    
    func testSubmitMultiProductSubmission() {
        let expectation = self.expectation(description: "testSubmitMultiProductSubmission")
        let multiRequest = BVMultiProductSubmission(userToken:  "TOKEN_REMOVED", productIds: ["product1", "product2", "product3"])
        
        multiRequest.submit({ (submittedMultiProduct) in
            expectation.fulfill()
            XCTAssertTrue( submittedMultiProduct.result?.products.count == 3)
        }, failure: { (errors) in
            expectation.fulfill()
            print(errors)
            XCTFail()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSubmitMultiProductSubmissionFailure() {
        let expectation = self.expectation(description: "testSubmitMultiProductSubmissionFailure")
        let multiRequest = BVMultiProductSubmission(userToken:" ", productIds: ["product1", "product2", "product3"])
        
        multiRequest.submit({ (submittedMultiProduct) in
            expectation.fulfill()
            XCTFail()
        }, failure: { (errors) in
            expectation.fulfill()
            XCTAssertTrue( errors.count == 1)
            print(errors)
        })
        waitForExpectations(timeout: 10, handler: nil)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
