//
//  BulkProductTests.swift
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import XCTest

class BulkProductTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": "caB45h2jBqXFw1OE043qoMBD1gJC8EwFNCjktzgwncXY4"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testBulkProductIncentivizedStats() {
    let expectation = self.expectation(description: "testBulkProductIncentivizedStats")
    
    let request = BVBulkProductRequest()
    request.load({ (response) in
      
      print(response.results.count)
      
      expectation.fulfill()
    }) { (error) in
       XCTFail("product display request error: \(error)")
       expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 10000) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
  }
}
