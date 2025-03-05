//
//  BVSummarisedFeaturesQueryTest.swift
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSDK

final class BVSummarisedFeaturesQueryTest: XCTestCase {
    
    override func setUp() {
      super.setUp()
      let configDict = ["clientId": "bv-beauty",
                        "apiKeyProductSentiments": BVTestUsers().loadValueForKey(key: .conversationsKeyBVBeauty)];
      BVSDKManager.configure(withConfiguration: configDict, configType: .prod)
      BVSDKManager.shared().setLogLevel(BVLogLevel.verbose)
      BVSDKManager.shared().urlSessionDelegate = nil;
    }
    
    override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
    }

    func testProductSummarisedFeatures() {
        let expectation = self.expectation(description: "testProductSummarisedFeatures")
        let request = BVSummarisedFeaturesRequest(productId: "P000010", language: "en", embed: "quotes")
        request.load({ response in
            guard let bestFeatures = response.result.bestFeatures, let feature = bestFeatures.first else {
                XCTFail("No feature received")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(feature.nativeFeature, "removal")
            XCTAssertNotNil(feature.embedded?.quotes)
            expectation.fulfill()
        }) { (errors) in
            for error in errors {
                XCTAssert((error as NSError).bvProductSentimentsErrorCode() == BVProductSentimentsErrorCode.noContent)
                XCTFail("product sentiments request error: \(error)")
            }
            expectation.fulfill()
          }
        self.waitForExpectations(timeout: 120) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testProductSummarisedFeaturesWithoutQuotes() {
        let expectation = self.expectation(description: "testProductSummarisedFeaturesWithoutQuotes")
        let request = BVSummarisedFeaturesRequest(productId: "P000010", language: "en", embed: "")
        request.load({ response in
            guard let bestFeatures = response.result.bestFeatures, let feature = bestFeatures.first else {
                XCTFail("No feature received")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(feature.nativeFeature, "removal")
            XCTAssertNil(feature.embedded?.quotes)
            expectation.fulfill()
        }) { (errors) in
            for error in errors {
                XCTAssert((error as NSError).bvProductSentimentsErrorCode() == BVProductSentimentsErrorCode.noContent)
                XCTFail("product sentiments request error: \(error)")
            }
            expectation.fulfill()
          }
        self.waitForExpectations(timeout: 60) { (error) in
          XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testProductSummarisedFeaturesFailureNoContent() {
        let expectation = self.expectation(description: "testProductSummarisedFeaturesFailureNoContent")
        let request = BVSummarisedFeaturesRequest(productId: "P00001", language: "en", embed: "quotes")
        request.load({ response in
            XCTFail("Query should fail")
            expectation.fulfill()
        }) { (errors) in
            for error in errors {
                print(error.localizedDescription)
                XCTAssert((error as NSError).bvProductSentimentsErrorCode() == BVProductSentimentsErrorCode.noContent)
            }
            expectation.fulfill()
          }
        self.waitForExpectations(timeout: 120) { (error) in
          XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testProductSummarisedFeaturesFailureInvalidEmbed() {
        let expectation = self.expectation(description: "testProductSummarisedFeaturesFailureInvalidEmbed")
        let request = BVSummarisedFeaturesRequest(productId: "P000010", language: "en", embed: "quote")
        request.load({ response in
            XCTFail("Query should fail")
            expectation.fulfill()
        }) { (errors) in
            for error in errors {
                print(error.localizedDescription)
                XCTAssert((error as NSError).bvProductSentimentsErrorCode() == BVProductSentimentsErrorCode.badRequest)
            }
            expectation.fulfill()
          }
        self.waitForExpectations(timeout: 60) { (error) in
          XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
}
