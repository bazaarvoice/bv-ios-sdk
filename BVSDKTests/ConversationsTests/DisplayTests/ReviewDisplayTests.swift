//
//  ReviewDisplayTests.swift
//  BVSDKTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import BVSDK

class ReviewDisplayTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": "kuy3zj9pr3n7i0wxajrzj04xo"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    BVSDKManager.shared().setLogLevel(BVLogLevel.verbose)
  }
  
  override func tearDown() {
    super.tearDown()
    OHHTTPStubs.removeAllStubs()
    
  }
  
    func testReviewDisplay() {
        
        let expectation = self.expectation(description: "testReviewDisplay")
        
        let request = BVReviewsRequest(productId: "test1", limit: 10, offset: 4)
            .sort(by: .reviewRating, monotonicSortOrderValue: .ascending)
            .filter(on: .hasPhotos, relationalFilterOperatorValue: .equalTo, value: "true")
            .filter(on: .hasComments, relationalFilterOperatorValue: .equalTo, value: "false")
        
        request.load({ (response) in
            
            XCTAssertEqual(response.results.count, 10)
            let review = response.results.first!
            XCTAssertEqual(review.rating, 1)
            XCTAssertEqual(review.title, "Vestibulum lobortis, diam at convallis hendrerit, augue ipsum fermentum neque, pharetra accumsan dui odio atfelis. Phas")
            XCTAssertEqual(review.reviewText, "Nullam quam purus, blandit quis convallis nec, mattis idenim. Fusce nec massa quis nibh dapibusmolestie. Quisque fermentum suscipit mauris, in tincidunt lectus tempusin.")
            XCTAssertEqual(review.moderationStatus, "APPROVED")
            XCTAssertEqual(review.identifier, "192432")
            XCTAssertNil(review.product)
            XCTAssertEqual(review.isRatingsOnly, false)
            XCTAssertEqual(review.isSyndicated, false)
            XCTAssertEqual(review.isFeatured, false)
            XCTAssertEqual(review.productId, "test1")
            XCTAssertEqual(review.authorId, "1q0mz2ni4is")
            XCTAssertEqual(review.userNickname, "h1VXaRZwbvy")
            XCTAssertNil(review.userLocation, "San Fransisco, California")
            //XCTAssertNil(review.syndicationSource)
            
            XCTAssertEqual((review.tagDimensions!["Pro"]! as AnyObject).label, "Pros")
            XCTAssertEqual((review.tagDimensions!["Pro"]! as AnyObject).identifier, "Pro")
            XCTAssertEqual((review.tagDimensions!["Pro"]! as AnyObject).values!!, ["Pro 2", "ma"])
            
            XCTAssertEqual(review.photos.count, 6)
            XCTAssertNil(review.photos.first?.caption, "Etiam malesuada ultricies urna in scelerisque. Sed viverra blandit nibh non egestas. Sed rhoncus, ipsum in vehicula imperdiet, purus lectus sodales erat, eget ornare lacus lectus ac leo. Suspendisse tristique sollicitudin ultricies. Aliquam erat volutpat.")
            XCTAssertEqual(review.photos.first?.identifier, "79880")
            XCTAssertNotNil(review.photos.first?.sizes?.thumbnailUrl)
            
            // Not getting this Object
            /*
             XCTAssertEqual(review.contextDataValues.count, 1)
             let cdv = review.contextDataValues.first!
             XCTAssertEqual(cdv.value, "Female")
             XCTAssertEqual(cdv.valueLabel, "Female")
             XCTAssertEqual(cdv.dimensionLabel, "Gender")
             XCTAssertEqual(cdv.identifier, "Gender")
             
             XCTAssertEqual(review.badges.first?.badgeType, BVBadgeType.merit)
             XCTAssertEqual(review.badges.first?.identifier, "top10Contributor")
             XCTAssertEqual(review.badges.first?.contentType, "REVIEW")
             
             */
            
            response.results.forEach { (review) in
                XCTAssertEqual(review.productId, "test1")
            }
            
            expectation.fulfill()
            
        }) { (error) in
            
            XCTFail("review display request error: \(error)")
            
        }
        
        self.waitForExpectations(timeout: 1000) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }
  
  
  func testSyndicationSource(){
    
    
    stub(condition: isHost("stg.api.bazaarvoice.com")) { _ in
      let stubPath = OHPathForFile("testSyndicationSource.json", type(of: self))
      return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject:"application/json" as AnyObject])
    }
    
    let expectation = self.expectation(description: "testSyndicationSource")
    
    
    let request = BVReviewsRequest(productId: "test1", limit: 10, offset: 4)
      .sort(by: .reviewRating, monotonicSortOrderValue: .descending)
      .include(.reviewProducts)
    
    request.load({ (response) in
      
      let review = response.results.first
      
      XCTAssertNotNil(review?.syndicationSource)
      XCTAssertEqual(review?.syndicationSource?.name, "bazaarvoice")
      XCTAssertNil(review?.syndicationSource?.contentLink)
      XCTAssertNotNil(review?.syndicationSource?.logoImageUrl)
      
      expectation.fulfill()
      
    }) { (error) in
      
      XCTFail("review display request error: \(error)")
      expectation.fulfill()
      
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
    func testReviewDisplayProductFilteredStats() {
        
        let expectation = self.expectation(description: "testReviewDisplayProductFilteredStats")
        
        let request = BVReviewsRequest(productId: "test1", limit: 10, offset: 4)
            .sort(by: .reviewRating, monotonicSortOrderValue: .ascending)
            .filter(on: .hasPhotos, relationalFilterOperatorValue: .equalTo, value: "true")
            .filter(on: .hasComments, relationalFilterOperatorValue: .equalTo, value: "false")
            .include(.reviewProducts)
            .addCustomDisplayParameter("filteredstats", withValue: "reviews,questions")
        
        request.load({ (response) in
            
            XCTAssertEqual(response.results.count, 10)
            let review = response.results.first!
          
            XCTAssertNotNil(review.product)
            XCTAssertNotNil(review.product?.reviewStatistics)
            XCTAssertNotNil(review.product?.filteredReviewStatistics)
            XCTAssertNotNil(review.product?.qaStatistics)
            
            XCTAssertNotNil(review.product?.reviewStatistics?.contextDataDistribution)
            XCTAssertNotNil(review.product?.reviewStatistics?.tagDistribution)
            XCTAssertNotNil(review.product?.reviewStatistics?.ratingDistribution)
          
            XCTAssertNotNil(review.product?.filteredReviewStatistics?.contextDataDistribution)
            XCTAssertNotNil(review.product?.filteredReviewStatistics?.tagDistribution)
            XCTAssertNotNil(review.product?.filteredReviewStatistics?.ratingDistribution)
            
            let qualityAvg = review.product?.reviewStatistics?.secondaryRatingsAverages?["Quality"] as! NSNumber;
            let valueAvg = review.product?.reviewStatistics?.secondaryRatingsAverages?["Value"] as! NSNumber;
            
            XCTAssertTrue(qualityAvg.intValue > 0)
            XCTAssertTrue(valueAvg.intValue > 0)
          
            let filteredReviewStatsQualityAvg = review.product?.filteredReviewStatistics?.secondaryRatingsAverages?["Quality"] as! NSNumber;
            let filteredReviewStatsValueAvg = review.product?.filteredReviewStatistics?.secondaryRatingsAverages?["Value"] as! NSNumber;
            
            XCTAssertTrue(filteredReviewStatsQualityAvg.intValue > 0)
            XCTAssertTrue(filteredReviewStatsValueAvg.intValue > 0)
              
            XCTAssertEqual(review.identifier, "192432")
            
            XCTAssertEqual(review.isRatingsOnly, false)
            XCTAssertEqual(review.isFeatured, false)
            XCTAssertEqual(review.productId, "test1")
            XCTAssertEqual(review.authorId, "1q0mz2ni4is")
            XCTAssertEqual(review.userNickname, "h1VXaRZwbvy")
            XCTAssertNil(review.userLocation, "Baltimore, Maryland")
            
            XCTAssertEqual((review.tagDimensions!["Pro"]! as AnyObject).label, "Pros")
            XCTAssertEqual((review.tagDimensions!["Pro"]! as AnyObject).identifier, "Pro")
            XCTAssertEqual((review.tagDimensions!["Pro"]! as AnyObject).values!!, ["Pro 2", "ma"])
            
            XCTAssertEqual(review.photos.count, 6)
            XCTAssertNil(review.photos.first?.caption, "Etiam malesuada ultricies urna in scelerisque. Sed viverra blandit nibh non egestas. Sed rhoncus, ipsum in vehicula imperdiet, purus lectus sodales erat, eget ornare lacus lectus ac leo. Suspendisse tristique sollicitudin ultricies. Aliquam erat volutpat.")
            XCTAssertEqual(review.photos.first?.identifier, "79880")
            XCTAssertNotNil(review.photos.first?.sizes?.thumbnailUrl)
            
            XCTAssertEqual(review.contextDataValues.count, 0)
            print(review.contextDataValues.count)
            
            // Not getting this Object
            /*
             let cdv = review.contextDataValues.first!
             XCTAssertEqual(cdv.value, "Female")
             XCTAssertEqual(cdv.valueLabel, "Female")
             XCTAssertEqual(cdv.dimensionLabel, "Gender")
             XCTAssertEqual(cdv.identifier, "Gender")
             
             XCTAssertEqual(review.badges.first?.badgeType, BVBadgeType.merit)
             XCTAssertEqual(review.badges.first?.identifier, "top10Contributor")
             XCTAssertEqual(review.badges.first?.contentType, "REVIEW")
             */
            response.results.forEach { (review) in
                XCTAssertEqual(review.productId, "test1")
            }
            
            expectation.fulfill()
            
        }) { (error) in
            
            XCTFail("product display request error: \(error)")
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }
  
  func testReviewIncludeComments() {
    
    let expectation = self.expectation(description: "testReviewIncludeComments")
    
    let request = BVReviewsRequest(productId: "test1", limit: 10, offset: 0)
      .include(.reviewComments)
      .filter(on: .id, relationalFilterOperatorValue: .equalTo, value: "192463") // This review is know to have a comment
    
    request.load({ (response) in
      
      XCTAssertEqual(response.results.count, 1) // We filtered on a review id, so there should only be one
      
      let review : BVReview = response.results.first!
      
      XCTAssertTrue(review.includedComments.count >= 1)
      
      let firstComment = review.includedComments.first!
      
      // XCTAssertNotNil(firstComment.title) -- title may be nil
      XCTAssertNotNil(firstComment.authorId)
      XCTAssertNotNil(firstComment.badges)
      XCTAssertNotNil(firstComment.submissionTime)
      XCTAssertNotNil(firstComment.commentText)
      XCTAssertNotNil(firstComment.contentLocale)
      XCTAssertNotNil(firstComment.lastModeratedTime)
      XCTAssertNotNil(firstComment.lastModificationTime)
      
      expectation.fulfill()
      
    }) { (error) in
      
      XCTFail("review display request error: \(error)")
      
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
}
