//
//  ConversationsStoresDisplayTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import BVSDK

class ConversationsStoresDisplayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        BVSDKManager.sharedManager().clientId = "acmestores"
        BVSDKManager.sharedManager().apiKeyConversationsStores = "mocktestingnokeyrequired"
        BVSDKManager.sharedManager().staging = false
        BVSDKManager.sharedManager().setLogLevel(.Error)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // This tests fetching reviews from a single store, but store id, given a limit and offset.
    func testStoreFeedDisplayWithReviewsAndStats() {
        
        stub(isHost("api.bazaarvoice.com")) { _ in
            // Stub it with our "storeItemWithStatsAndReviews.json" stub file (which is in same bundle as self)
            let stubPath = OHPathForFile("storeItemWithStatsAndReviews.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        let expectation = expectationWithDescription("testStoreFeedDisplayWithReviews")
        
        let request = BVStoreReviewsRequest(storeId: "1", limit: 20, offset: 0)
        request.includeStatistics(.Reviews) // Include statistics on the store object
        request.addSort(.Rating, order: .Descending)      // sort the reviews by rating, from top rated to lowest rated
        request.load({ (response) in
            // Success
            // Check the store attributes
            let store : BVStore = response.store!
            
            XCTAssertEqual(store.identifier, "1")
            XCTAssertEqual(store.name, "Endurance Cycles Austin")
            XCTAssertEqual(store.productDescription, "10901 Stonelake Blvd, Austin, TX 78759")
            XCTAssertEqual(store.productPageUrl, "http://www.endurancecycles.com/")
            XCTAssertEqual(store.imageUrl, "http://media.bizj.us/view/img/8513272/bazaarvoice-1-exterior*750xx900-506-0-1.jpg")
            
            // Check that the store has a location
            XCTAssertNotNil(store.storeLocation, "storeLocation should not be nil")

            XCTAssertEqual(response.results.count, 12)
            
            for currReview in response.results {
                // make sure we have some review text in each BVReview object
                
                XCTAssertTrue(currReview.productId != nil, "store productId id should never be nil in a review")
                XCTAssertTrue(currReview.authorId != nil, "authorId should never be nil in a review")
            }
            
            XCTAssertNotNil(store.reviewStatistics, "store reviewStatistics should not be nil")
            XCTAssertEqual(store.reviewStatistics?.averageOverallRating, 4.75)
            XCTAssertEqual(store.reviewStatistics?.totalReviewCount, 12)
            
            expectation.fulfill()
            
        }) { (error) in
            // Fail
            XCTFail("Unexpected error in text")
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
    // Testing reading of multiple stores, paged by limit and offsest
    func testBulkStoresFetching() {
        
        let expectation = expectationWithDescription("testBulkStoresFetching")
        
        stub(isHost("api.bazaarvoice.com")) { _ in
            // Stub it with our "storeBulkFeedWithStatistics.json" stub file (which is in same bundle as self)
            let stubPath = OHPathForFile("storeBulkFeedWithStatistics.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        let request = BVBulkStoreItemsRequest(20, offset: 0)
        request.includeStatistics(.Reviews)
        request.load({ (response) in
            // Success
            XCTAssertEqual(response.results.count, response.totalResults)

            for store : BVStore in response.results {

                XCTAssertNotNil(store, "Store in feed should not be nil")
                XCTAssertNotNil(store.productDescription, "Store description nil")
                XCTAssertNotNil(store.storeLocation, "Store in feed should not be nil")

                XCTAssertNotNil(store.storeLocation?.longitude, "longitude should not be nil")
                XCTAssertNotNil(store.storeLocation?.latitude, "latitude should not be nil")
                XCTAssertNotNil(store.storeLocation?.city, "city should not be nil")
                XCTAssertNotNil(store.storeLocation?.state, "state should not be nil")
                XCTAssertNotNil(store.storeLocation?.postalcode, "postalcode should not be nil")
                XCTAssertNotNil(store.storeLocation?.phone, "phone should not be nil")
                
                XCTAssertNotNil(store.reviewStatistics, "reviewStatistics for a store should not be nil")
                
            }

            expectation.fulfill()
        }) { (error) in
            // Fail
            XCTFail("Unexpected error in text")
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
    
    // Testing reading of multiple stores, paged
    func testFetchStoresByIds() {
        
        let expectation = expectationWithDescription("testFetchStoresByIds")
        
        stub(isHost("api.bazaarvoice.com")) { _ in
            // Stub it with our "storeFeedOneStore.json" stub file (which is in same bundle as self)
            let stubPath = OHPathForFile("storeFetchByIds.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        // Fetch two stores, by ID
        let request = BVBulkStoreItemsRequest(storeIds:["1", "3"])
        request.includeStatistics(.Reviews)
        request.load({ (response) in
            // Success
            XCTAssertEqual(response.results.count, response.totalResults)
            
            for store : BVStore in response.results {
                
                XCTAssertNotNil(store, "Store in feed should not be nil")
                XCTAssertNotNil(store.productDescription, "Store description nil")
                XCTAssertNotNil(store.storeLocation, "Store in feed should not be nil")
                
                XCTAssertNotNil(store.storeLocation?.longitude, "longitude should not be nil")
                XCTAssertNotNil(store.storeLocation?.latitude, "latitude should not be nil")
                XCTAssertNotNil(store.storeLocation?.city, "city should not be nil")
                XCTAssertNotNil(store.storeLocation?.state, "state should not be nil")
                XCTAssertNotNil(store.storeLocation?.postalcode, "postalcode should not be nil")
                XCTAssertNotNil(store.storeLocation?.phone, "phone should not be nil")
                
                XCTAssertNotNil(store.reviewStatistics, "reviewStatistics for a store should not be nil")
            }
            
            expectation.fulfill()
        }) { (error) in
            // Fail
            XCTFail("Unexpected error in text")
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }

    // Test an empty response, e.g. when we provide a store id that does not exist
    func testNoStoreFoundResult() {
        
        let expectation = expectationWithDescription("testNoStoreFoundResult")
        
        stub(isHost("api.bazaarvoice.com")) { _ in
            // Stub it with our "storeFeedOneStore.json" stub file (which is in same bundle as self)
            let stubPath = OHPathForFile("storeNoStoresFoundResult.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        // Fetch two stores, by ID
        let request = BVBulkStoreItemsRequest(storeIds:["badid"])
        request.includeStatistics(.Reviews)
        request.load({ (response) in
            // Success
            XCTAssertEqual(response.results.count, response.totalResults)
        
            expectation.fulfill()
        }) { (error) in
            // Fail
            XCTFail("Unexpected error in text")
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
}
