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
            guard let result = response.result else {
                XCTFail("Expected response")
                expectation.fulfill()
                return
            }
            guard let data = result.tokens else {
                XCTFail("Expected tokens")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(data.count, 2)
            expectation.fulfill()
            
        }) { (errors) in
            print("matched tokens request error: \(errors)")
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
}

