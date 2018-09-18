//
//  ConversationsStoresDisplayTests.swift
//  BVSDKTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import BVSDK

class ConversationsStoresDisplayTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    let configDict = ["clientId": "acmestores",
                      "apiKeyConversationsStores": "mocktestingnokeyrequired"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .prod)
    BVSDKManager.shared().setLogLevel(.error)
  }
  
  override func tearDown() {
    super.tearDown()
    OHHTTPStubs.removeAllStubs()
  }
  
  // This tests fetching reviews from a single store, but store id, given a limit and offset.
  func testStoreFeedDisplayWithReviewsAndStats() {
    
    stub(condition: isHost("api.bazaarvoice.com")) { _ in
      // Stub it with our "storeItemWithStatsAndReviews.json" stub file (which is in same bundle as self)
      let stubPath = OHPathForFile("storeItemWithStatsAndReviews.json", type(of: self))
      return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject:"application/json" as AnyObject])
    }
    
    let expectation = self.expectation(description: "testStoreFeedDisplayWithReviews")
    
    let request = BVStoreReviewsRequest(storeId: "1", limit: 20, offset: 0)
    request.includeStatistics(.reviews) // Include statistics on the store object
      .include(.reviewComments)
    //request.addInclude(BVReviewIncludeType.products)
      .sort(by: .reviewRating, monotonicSortOrderValue: .descending) // sort the reviews by rating, from top rated to lowest rated
    
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
        
        XCTAssertNotNil(currReview.productId, "store productId id should never be nil in a review")
        XCTAssertNotNil(currReview.authorId, "authorId should never be nil in a review")
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
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
  // Testing reading of multiple stores, paged by limit and offsest
  func testBulkStoresFetching() {
    
    let expectation = self.expectation(description: "testBulkStoresFetching")
    
    stub(condition: isHost("api.bazaarvoice.com")) { _ in
      // Stub it with our "storeBulkFeedWithStatistics.json" stub file (which is in same bundle as self)
      let stubPath = OHPathForFile("storeBulkFeedWithStatistics.json", type(of: self))
      return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject:"application/json" as AnyObject])
    }
    
    let request = BVBulkStoreItemsRequest(20, offset: 0)
    request.includeStatistics(.reviews)
    request.load({ (response) in
      // Success
      XCTAssertEqual(Int(response.results.count), Int(truncating: response.totalResults!))
      
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
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
  
  // Testing reading of multiple stores, paged
  func testFetchStoresByIds() {
    
    let expectation = self.expectation(description: "testFetchStoresByIds")
    
    stub(condition: isHost("api.bazaarvoice.com")) { _ in
      // Stub it with our "storeFeedOneStore.json" stub file (which is in same bundle as self)
      let stubPath = OHPathForFile("storeFetchByIds.json", type(of: self))
      return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject:"application/json" as AnyObject])
    }
    
    // Fetch two stores, by ID
    let request = BVBulkStoreItemsRequest(storeIds:["1", "3"])
    request.includeStatistics(.reviews)
    request.load({ (response) in
      // Success
      XCTAssertEqual(Int(response.results.count), Int(truncating: response.totalResults!))
      
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
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
  // Test an empty response, e.g. when we provide a store id that does not exist
  func testNoStoreFoundResult() {
    
    let expectation = self.expectation(description: "testNoStoreFoundResult")
    
    stub(condition: isHost("api.bazaarvoice.com")) { _ in
      // Stub it with our "storeFeedOneStore.json" stub file (which is in same bundle as self)
      let stubPath = OHPathForFile("storeNoStoresFoundResult.json", type(of: self))
      return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject:"application/json" as AnyObject])
    }
    
    // Fetch two stores, by ID
    let request = BVBulkStoreItemsRequest(storeIds:["badid"])
    request.includeStatistics(.reviews)
    request.load({ (response) in
      // Success
      XCTAssertEqual(Int(response.results.count), Int(truncating: response.totalResults!))
      
      expectation.fulfill()
    }) { (error) in
      // Fail
      XCTFail("Unexpected error in text")
      expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
}
