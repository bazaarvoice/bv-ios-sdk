//
//  FeatureDisplayTests.swift
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
//

import XCTest
import Foundation
@testable import BVSDK

// Tests conforming to API description at: https://developer.bazaarvoice.com/docs/read/conversations_api/reference/latest/profiles/display
class FeatureDisplayTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    let configDict = ["clientId": "testcustomer-concierge-regression",
                      "apiKeyConversations": "KEY_REMOVED"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    BVSDKManager.shared().setLogLevel(.verbose)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testFeaturesDisplay() {
    
    let expectation = self.expectation(description: "testFeaturesDisplay")
    
    let request = BVFeaturesRequest(productId: "XYZ123-prod-3-4-ExternalId")
    
    request.load({ (response) in
      // success
      
      expectation.fulfill()
      
      let bvfeatures = response.results.first!
      
      XCTAssertEqual(response.results.count, 1)
      XCTAssertEqual(bvfeatures.productId, "XYZ123-prod-3-4-ExternalId")
      XCTAssertEqual(bvfeatures.language, "en")
        
      
      XCTAssertEqual(bvfeatures.features.first!.feature,"speed")
      XCTAssertEqual(bvfeatures.features.first!.localizedFeature,"speed")

    }) { (error) in
      
      XCTFail("Features display request error: \(error)")
      expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 10000) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
  }
  
  
    func testFeaturesUnsupportedLanguage() {
      
      let expectation = self.expectation(description: "testFeaturesUnsupportedLanguage")
      
        let request = BVFeaturesRequest(productId: "XYZ123-prod-3-4-ExternalId",language: "hi")
      
      request.load({ (response) in
        XCTFail()
        expectation.fulfill()

      }) { (error) in
        
        XCTAssert((error.first! as NSError).bvErrorCode() == BVErrorCode.paramInvalidLocale)
        expectation.fulfill()
      }
      
      self.waitForExpectations(timeout: 10000) { (error) in
        XCTAssertNil(error, "Something went horribly wrong, request took too long.")
      }
    }
  
}
