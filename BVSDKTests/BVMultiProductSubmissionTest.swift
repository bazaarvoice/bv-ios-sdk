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
                          "apiKeyConversations": "caaT5bqrrDbwXgbgtR59cHPes3tdfUB4l6DxPpxXAk06g"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.verbose)
    }
    
    func testSubmitMultiProductSubmission() {
        let expectation = self.expectation(description: "testSubmitMultiProductSubmission")
        let multiRequest = BVMultiProductSubmission(userToken:  "aa9ee3b1a7cad43c449243b96c920c95245f053215e6b9e75c2645cd0860b3b66d61786167653d333026484f535445443d564552494649454426646174653d323031393033313826656d61696c616464726573733d627674657374757365723833383338334062762e636f6d267573657269643d6c6f63616c2d31353532393338363433323230", productIds: ["product1", "product2", "product3"])
        
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
