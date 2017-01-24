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
        
        BVSDKManager.shared().clientId = "apitestcustomer"
        BVSDKManager.shared().apiKeyConversations = "kuy3zj9pr3n7i0wxajrzj04xo"
        BVSDKManager.shared().staging = true
    }
    
    
    func testProductDisplay() {
        
        let expectation = self.expectation(description: "")

        let request = BVProductDisplayPageRequest(productId: "test1")
            .include(PDPContentType.reviews, limit: 10)
            .include(.reviews, limit: 10)
            .include(.questions, limit: 5)
            .includeStatistics(.reviews)
        
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
            expectation.fulfill()
            
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
}
