//
//  ConversationsDisplayTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class ConversationsDisplayTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": "KEY_REMOVED"];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testProductDisplay() {
    
    let expectation = self.expectation(description: "")
    
    let request = BVProductDisplayPageRequest(productId: "test1")
      .include(.reviews, limit: 10)
      .include(.questions, limit: 5)
    
    //      .include(.reviews, limit: 10)
    //      .include(.questions, limit: 5)
    //      .includeStatistics(.reviews)
    
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
  
  func testReviewDisplay() {
    
    let expectation = self.expectation(description: "")
    
    let request = BVReviewsRequest(productId: "test1", limit: 10, offset: 4)
      .sort(by: .reviewRating, monotonicSortOrderValue: .ascending)
      .filter(on: .hasPhotos, relationalFilterOperatorValue: .equalTo, value: "true")
      .filter(on: .hasComments, relationalFilterOperatorValue: .equalTo, value: "false")
    
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
      XCTAssertNotNil(review.photos.first?.sizes?.thumbnailUrl)
      
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
  
  func testQuestionDisplay() {
    
    let expectation = self.expectation(description: "")
    
    let request = BVQuestionsAndAnswersRequest(productId: "test1", limit: 10, offset: 0)
      .filter(on: .questionHasAnswers, relationalFilterOperatorValue: .equalTo, value: "true")
    
    request.load({ (response) in
      
      XCTAssertEqual(response.results.count, 10)
      
      let question = response.results.first!
      XCTAssertEqual(question.questionSummary, "Das ist mein test :)")
      XCTAssertEqual(question.questionDetails, "Das ist mein test :)")
      XCTAssertEqual(question.userNickname, "123thisisme")
      XCTAssertEqual(question.authorId, "eplz083100g")
      XCTAssertEqual(question.moderationStatus, "APPROVED")
      XCTAssertEqual(question.identifier, "14828")
      
      XCTAssertEqual(question.includedAnswers.count, 1)
      
      let answer = question.includedAnswers.first!
      XCTAssertEqual(answer.userNickname, "asdfasdfasdfasdf")
      XCTAssertEqual(answer.questionId, "14828")
      XCTAssertEqual(answer.authorId, "c6ryqeb2bq0")
      XCTAssertEqual(answer.moderationStatus, "APPROVED")
      XCTAssertEqual(answer.identifier, "16292")
      XCTAssertEqual(answer.answerText, "zxnc,vznxc osaidmf oaismdfo ims adoifmaosidmfoiamsdfimasdf")
      
      response.results.forEach { (question) in
        XCTAssertEqual(question.productId, "test1")
      }
      
      expectation.fulfill()
      
    }) { (error) in
      
      XCTFail("product display request error: \(error)")
      expectation.fulfill()
      
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
  
  func testInlineRatingsDisplayOneProduct() {
    
    let expectation = self.expectation(description: "")
    
    let request =
      BVBulkRatingsRequest(productIds: ["test3"], statistics: .bulkRatingAll)
        .filter(on: .bulkRatingContentLocale, relationalFilterOperatorValue: .equalTo, values: ["en_US"])
    
    request.load({ (response) in
      XCTAssertEqual(response.results.count, 1)
      XCTAssertEqual(response.results[0].productId, "test3")
      XCTAssertEqual(response.results[0].reviewStatistics?.totalReviewCount, 29)
      XCTAssertNotNil(response.results[0].reviewStatistics?.averageOverallRating)
      XCTAssertEqual(response.results[0].reviewStatistics?.overallRatingRange, 5)
      XCTAssertEqual(response.results[0].nativeReviewStatistics?.totalReviewCount, 29)
      XCTAssertEqual(response.results[0].nativeReviewStatistics?.overallRatingRange, 5)
      expectation.fulfill()
    }) { (error) in
      XCTFail("inline ratings request error: \(error)")
      expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
  func testInlineRatingsDisplayMultipleProducts() {
    
    let expectation = self.expectation(description: "")
    
    let request =
      BVBulkRatingsRequest(productIds: ["test1", "test2", "test3"], statistics: .bulkRatingAll)
        .filter(on: .bulkRatingContentLocale, relationalFilterOperatorValue: .equalTo, values: ["en_US"])
    
    request.load({ (response) in
      XCTAssertEqual(response.results.count, 3)
      expectation.fulfill()
    }) { (error) in
      XCTFail("inline ratings request error: \(error)")
      expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 10) { (error) in print("request took way too long") }
  }
  
  func testInlineRatingsTooManyProductsError() {
    
    let expectation = self.expectation(description: "inline ratings display should complete")
    
    var tooManyProductIds: [String] = []
    
    for i in 0 ... 110{
      tooManyProductIds += [String(i)]
    }
    
    
    let request = BVBulkRatingsRequest(productIds: tooManyProductIds, statistics: .bulkRatingAll)
    
    request.load({ (response) in
      XCTFail("Should not succeed")
    }) { (error) in
      expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
}
