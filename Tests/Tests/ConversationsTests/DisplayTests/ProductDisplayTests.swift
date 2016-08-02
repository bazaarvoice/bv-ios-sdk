//
//  ProductDisplayTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class ProductDisplayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        BVSDKManager.sharedManager().clientId = "apitestcustomer"
        BVSDKManager.sharedManager().apiKeyConversations = "kuy3zj9pr3n7i0wxajrzj04xo"
        BVSDKManager.sharedManager().staging = true
    }
    
    
    func testProductDisplay() {
        
        let expectation = expectationWithDescription("")

        let request = BVProductDisplayPageRequest(productId: "test1")
            .includeContent(PDPContentType.Reviews, limit: 10)
            .includeContent(.Reviews, limit: 10)
            .includeContent(.Questions, limit: 5)
            .includeStatistics(.Reviews)
        
        request.load({ (response) in
            
            XCTAssertNotNil(response.result)
            
            let product = response.result!
            let brand = product.brand!
            XCTAssertEqual(brand.identifier, "cskg0snv1x3chrqlde0zklodb")
            XCTAssertEqual(brand.name, "mysh")
            XCTAssertEqual(product.productDescription, "Our pinpoint oxford is crafted from only the finest 80\'s two-ply cotton fibers.Single-needle stitching on all seams for a smooth flat appearance. Tailored with our Traditional\n                straight collar and button cuffs. Machine wash. Imported.")
            XCTAssertEqual(product.brandExternalId, "cskg0snv1x3chrqlde0zklodb")
            XCTAssertEqual(product.imageUrl, "http://myshco.com/productImages/shirt.jpg")
            XCTAssertEqual(product.name, "Dress Shirt")
            XCTAssertEqual(product.categoryId, "testCategory1031")
            XCTAssertEqual(product.identifier, "test1")
            XCTAssertEqual(product.includedReviews.count, 10)
            XCTAssertEqual(product.includedQuestions.count, 5)
            expectation.fulfill()
            
        }) { (error) in
            
            XCTFail("product display request error: \(error)")
            
        }
        
        self.waitForExpectationsWithTimeout(10) { (error) in print("request took way too long") }
        
    }
    
}