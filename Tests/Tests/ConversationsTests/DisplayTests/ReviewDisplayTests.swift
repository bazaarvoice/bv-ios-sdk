//
//  ReviewDisplayTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class ReviewDisplayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let configDict = ["clientId": "apitestcustomer",
                          "apiKeyConversations": "KEY_REMOVED"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(BVLogLevel.verbose)
    }
    
    
    func testReviewDisplay() {
        
        let expectation = self.expectation(description: "testReviewDisplay")
        
        let request = BVReviewsRequest(productId: "test1", limit: 10, offset: 4)
            .addReviewSort(.rating, order: .ascending)
            .addFilter(.hasPhotos, filterOperator: .equalTo, value: "true")
            .addFilter(.hasComments, filterOperator: .equalTo, value: "false")
        
        request.load({ (response) in
            
            XCTAssertEqual(response.results.count, 10)
            let review = response.results.first!
            XCTAssertEqual(review.rating, 1)
            XCTAssertEqual(review.title, "Morbi nibh risus, mattis id placerat a massa nunc.")
            XCTAssertEqual(review.reviewText, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed rhoncus scelerisque semper. Morbi in sapien sit amet justo eleifend pellentesque! Cras sollicitudin, quam in ullamcorper faucibus, augue metus blandit justo, vitae ullamcorper tellus quam non purus. Fusce gravida rhoncus placerat. Integer tempus nunc sed elit mollis ut venenatis felis volutpat. Sed a velit et lacus lobortis aliquet? Donec dolor quam, pharetra vitae commodo et, mattis quis nibh? Quisque ultrices neque et lacus volutpat.")
            XCTAssertEqual(review.moderationStatus, "APPROVED")
            XCTAssertEqual(review.identifier, "191975")
            XCTAssertNil(review.product)
            XCTAssertEqual(review.isRatingsOnly, false)
            XCTAssertEqual(review.isFeatured, false)
            XCTAssertEqual(review.productId, "test1")
            XCTAssertEqual(review.authorId, "endersgame")
            XCTAssertEqual(review.userNickname, "endersgame")
            XCTAssertEqual(review.userLocation, "San Fransisco, California")
            
            XCTAssertEqual((review.tagDimensions!["Pro"]! as AnyObject).label, "Pros")
            XCTAssertEqual((review.tagDimensions!["Pro"]! as AnyObject).identifier, "Pro")
            XCTAssertEqual((review.tagDimensions!["Pro"]! as AnyObject).values!!, ["Organic Fabric", "Quality"])
            
            XCTAssertEqual(review.photos.count, 1)
            XCTAssertEqual(review.photos.first?.caption, "Etiam malesuada ultricies urna in scelerisque. Sed viverra blandit nibh non egestas. Sed rhoncus, ipsum in vehicula imperdiet, purus lectus sodales erat, eget ornare lacus lectus ac leo. Suspendisse tristique sollicitudin ultricies. Aliquam erat volutpat.")
            XCTAssertEqual(review.photos.first?.identifier, "72586")
            XCTAssertEqual(review.photos.first?.sizes?.thumbnailUrl, "https://reviews.apitestcustomer.bazaarvoice.com/bvstaging/5556/72586/photoThumb.jpg?client=APIReadOnlySandbox")
            XCTAssertEqual(review.photos.first?.sizes?.normalUrl, "https://reviews.apitestcustomer.bazaarvoice.com/bvstaging/5556/72586/photo.jpg?client=APIReadOnlySandbox")
            
            XCTAssertEqual(review.contextDataValues.count, 1)
            let cdv = review.contextDataValues.first!
            XCTAssertEqual(cdv.value, "Female")
            XCTAssertEqual(cdv.valueLabel, "Female")
            XCTAssertEqual(cdv.dimensionLabel, "Gender")
            XCTAssertEqual(cdv.identifier, "Gender")
            
            XCTAssertEqual(review.badges.first?.badgeType, BVBadgeType.merit)
            XCTAssertEqual(review.badges.first?.identifier, "top10Contributor")
            XCTAssertEqual(review.badges.first?.contentType, "REVIEW")
            
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
    
    
    func testReviewDisplayProductFilteredStats() {
        
        let expectation = self.expectation(description: "testReviewDisplayProductFilteredStats")
        
        let request = BVReviewsRequest(productId: "test1", limit: 10, offset: 4)
            .addReviewSort(.rating, order: .ascending)
            .addInclude(BVReviewIncludeType.products)
            .addFilter(.hasPhotos, filterOperator: .equalTo, value: "true")
            .addFilter(.hasComments, filterOperator: .equalTo, value: "false")
            .addAdditionalField("filteredstats", value: "reviews,questions")
        
        request.load({ (response) in
            
            XCTAssertEqual(response.results.count, 10)
            let review = response.results.first!
            XCTAssertEqual(review.rating, 1)
            
            XCTAssertNotNil(review.product)
            XCTAssertNotNil(review.product?.reviewStatistics)
            XCTAssertNotNil(review.product?.qaStatistics)
            
            XCTAssertNotNil(review.product?.reviewStatistics?.contextDataDistribution)
            XCTAssertNotNil(review.product?.reviewStatistics?.tagDistribution)
            XCTAssertNotNil(review.product?.reviewStatistics?.ratingDistribution)
            
            let qualityAvg = review.product?.reviewStatistics?.secondaryRatingsAverages?["Quality"] as! NSNumber;
            let valueAvg = review.product?.reviewStatistics?.secondaryRatingsAverages?["Value"] as! NSNumber;
            
            XCTAssertTrue(qualityAvg.intValue > 0)
            XCTAssertTrue(valueAvg.intValue > 0)
            
            XCTAssertEqual(review.identifier, "191975")
            
            XCTAssertEqual(review.isRatingsOnly, false)
            XCTAssertEqual(review.isFeatured, false)
            XCTAssertEqual(review.productId, "test1")
            XCTAssertEqual(review.authorId, "endersgame")
            XCTAssertEqual(review.userNickname, "endersgame")
            XCTAssertEqual(review.userLocation, "San Fransisco, California")
            
            XCTAssertEqual((review.tagDimensions!["Pro"]! as AnyObject).label, "Pros")
            XCTAssertEqual((review.tagDimensions!["Pro"]! as AnyObject).identifier, "Pro")
            XCTAssertEqual((review.tagDimensions!["Pro"]! as AnyObject).values!!, ["Organic Fabric", "Quality"])
            
            XCTAssertEqual(review.photos.count, 1)
            XCTAssertEqual(review.photos.first?.caption, "Etiam malesuada ultricies urna in scelerisque. Sed viverra blandit nibh non egestas. Sed rhoncus, ipsum in vehicula imperdiet, purus lectus sodales erat, eget ornare lacus lectus ac leo. Suspendisse tristique sollicitudin ultricies. Aliquam erat volutpat.")
            XCTAssertEqual(review.photos.first?.identifier, "72586")
            XCTAssertEqual(review.photos.first?.sizes?.thumbnailUrl, "https://reviews.apitestcustomer.bazaarvoice.com/bvstaging/5556/72586/photoThumb.jpg?client=APIReadOnlySandbox")
            XCTAssertEqual(review.photos.first?.sizes?.normalUrl, "https://reviews.apitestcustomer.bazaarvoice.com/bvstaging/5556/72586/photo.jpg?client=APIReadOnlySandbox")
            
            XCTAssertEqual(review.contextDataValues.count, 1)
            let cdv = review.contextDataValues.first!
            XCTAssertEqual(cdv.value, "Female")
            XCTAssertEqual(cdv.valueLabel, "Female")
            XCTAssertEqual(cdv.dimensionLabel, "Gender")
            XCTAssertEqual(cdv.identifier, "Gender")
            
            XCTAssertEqual(review.badges.first?.badgeType, BVBadgeType.merit)
            XCTAssertEqual(review.badges.first?.identifier, "top10Contributor")
            XCTAssertEqual(review.badges.first?.contentType, "REVIEW")
            
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

    
}
