//
//  MatchedTokensSubmissionTests.swift
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 


import XCTest
@testable import BVSDK

class MatchedTokensSubmissionTests: BVBaseStubTestCase {
    
    override func setUp() {
        super.setUp()
        
        let configDict = ["clientId": "apitestcustomer",
                          "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKeyBVBeauty)];
        BVSDKManager.configure(withConfiguration: configDict, configType: .prod)
        BVSDKManager.shared().setLogLevel(.error)
        
    }
    
    func testMatchedTokensQuery() {
        
        let expectation = self.expectation(description: "testMatchedTokensQuery")
        let testMatchedTokensQuery = BVMatchedTokensSubmission(productId: "P000036", withReviewText: "This product has great absorption and fragrance.")
        
        testMatchedTokensQuery.submit({ (response) in
            // success
            // verify response object....
            print(response.result?.data ?? "No data")
            XCTAssertNotNil(response.result)
            guard let result = response.result else {
                XCTFail("Expected response.result to be non-nil")
                expectation.fulfill()
                return
            }
            guard let data = result.data else {
                XCTFail("Expected response.result?.data to be non-nil")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(data.count, 2)
            expectation.fulfill()
            
        }) { (errors) in
            // error
            print(errors.first?.localizedDescription ?? "No error")
            XCTFail("Should not be in failure block")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
}

