//
//  ReviewFilterDisplayTest.swift
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSDK

class ReviewFilterDisplayTest: XCTestCase {

    override func setUp() {
        super.setUp()
        
        let configDict = ["clientId": "conciergeapidocumentation",
                          "apiKeyConversations": "KEY_REMOVED"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testProductIdReviewFilter() {
        
        let expectation = self.expectation(description: "")
        let productId = "data-gen-moppq9ekthfzbc6qff3bqokie"
        let request = BVReviewsRequest(id: productId, andFilter: BVReviewFilterValue.productId, limit: 10, offset: 0)
        
        request.load({ (response) in
            
            XCTAssertEqual(response.results.count, 10)
            response.results.forEach { (review) in
                XCTAssertEqual(review.productId, productId)
            }
            expectation.fulfill()
        }) { (error) in
            XCTFail("product display request error: \(error)")
        }
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testAuthorIdReviewFilter() {
        
        let expectation = self.expectation(description: "")
        let authorId = "data-gen-user-q329el4nt3x5p26bc88upxdj1"
        let request = BVReviewsRequest(id: authorId, andFilter: BVReviewFilterValue.authorId, limit: 10, offset: 0)
        
        request.load({ (response) in
            XCTAssertEqual(response.results.count, 10)
            response.results.forEach { (review) in
                XCTAssertEqual(review.authorId, authorId)
            }
            expectation.fulfill()
            
        }) { (error) in
            XCTFail("product display request error: \(error)")
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testSubmissionIdReviewFilter() {
        
        let expectation = self.expectation(description: "")
        let submisionId = "349y5dh9qv8grnc1v8j2tpucd"
        let request = BVReviewsRequest(id: submisionId, andFilter: BVReviewFilterValue.submissionId, limit: 10, offset: 0)
        
        request.load({ (response) in
            XCTAssertEqual(response.results.count, 1)
            let review = response.results.first!
            XCTAssertEqual(review.rating, 5)
            XCTAssertEqual(review.title, "Book of Eli")
            XCTAssertEqual(review.reviewText, ",Looks good!!Looks good!!,Looks good!!Looks good!!Looks good!!Looks good!!Looks good!!Looks good!!Looks good!!Looks good!!Looks good!!Looks good!!Looks good!!Looks good!!Looks good!!Looks good!!Looks good!!")
            XCTAssertEqual(review.moderationStatus, "APPROVED")
            XCTAssertEqual(review.identifier, "22466166")
            XCTAssertEqual(review.isRatingsOnly, false)
            XCTAssertEqual(review.isFeatured, false)
            XCTAssertEqual(review.productId, "data-gen-moppq9ekthfzbc6qff3bqokie")
            XCTAssertEqual(review.authorId, "SteveN")
            XCTAssertEqual(review.userNickname, "SteveN")
            expectation.fulfill()
            
        }) { (error) in
            XCTFail("product display request error: \(error)")
        }
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testDefaultProductIdReviewFilter() {
        
        let expectation = self.expectation(description: "")
        let productId = "data-gen-moppq9ekthfzbc6qff3bqokie"
        let request = BVReviewsRequest(productId: productId, limit: 10, offset: 0)
        
        request.load({ (response) in
            
            XCTAssertEqual(response.results.count, 10)
            response.results.forEach { (review) in
                XCTAssertEqual(review.productId, productId)
            }
            expectation.fulfill()
        }) { (error) in
            XCTFail("product display request error: \(error)")
        }
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testUnsuportedIdReviewFilter() {
        
        let expectation = self.expectation(description: "")
        let contentLocale = "en_US"
        let request = BVReviewsRequest(id: contentLocale, andFilter: BVReviewFilterValue.contentLocale, limit: 10, offset: 0)
        
        request.load({ (response) in
            
            XCTFail()
        }) { (errors) in
           let errorMessage = errors.first?.localizedDescription
           XCTAssertEqual(errorMessage, "ERROR_PARAM_INVALID_FILTER_ATTRIBUTE: Queries with Syndication can only be performed with a ProductId, AuthorId, CategoryAncestorId, SubmissionId, or Id EQ filter specified")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testNullIdReviewFilter() {
        
        let expectation = self.expectation(description: "")
        let productId = " "
        let request = BVReviewsRequest(productId: productId, limit: 10, offset: 0)
        request.load({ (response) in
            XCTFail()
        }) { (errors) in
            let errorMessage = errors.first?.localizedDescription
            XCTAssertEqual(errorMessage, "ERROR_PARAM_INVALID_FILTER_ATTRIBUTE: Invalid ProductId/Id Filter : Contains blank Left-Hand-Side value : ProductId:eq: ")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
}
