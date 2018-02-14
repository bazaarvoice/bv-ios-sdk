//
//  FilterTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK

class FilterTests: XCTestCase {
  
  func testOperatorStringify() {
    
    let productIdFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productId)
    
    let equalToFilterOperator:BVRelationalFilterOperator =
      BVRelationalFilterOperator(relationalFilterValue: .equalTo)
    
    let notEqualToFilterOperator:BVRelationalFilterOperator =
      BVRelationalFilterOperator(relationalFilterValue: .notEqualTo)
    
    let greaterThanFilterOperator:BVRelationalFilterOperator =
      BVRelationalFilterOperator(relationalFilterValue: .greaterThan)
    
    let greaterThanOrEqualToFilterOperator:BVRelationalFilterOperator =
      BVRelationalFilterOperator(relationalFilterValue: .greaterThanOrEqualTo)
    
    let lessThanFilterOperator:BVRelationalFilterOperator =
      BVRelationalFilterOperator(relationalFilterValue: .lessThan)
    
    let lessThanOrEqualToFilterOperator:BVRelationalFilterOperator =
      BVRelationalFilterOperator(relationalFilterValue: .lessThanOrEqualTo)
    
    XCTAssertEqual("Id:gt:test1",  BVFilter(filterType: productIdFilterType, filterOperator: greaterThanFilterOperator, value: "test1").toParameterString())
    XCTAssertEqual("Id:gte:test1", BVFilter(filterType: productIdFilterType, filterOperator: greaterThanOrEqualToFilterOperator, value: "test1").toParameterString())
    XCTAssertEqual("Id:lt:test1",  BVFilter(filterType: productIdFilterType, filterOperator: lessThanFilterOperator, value: "test1").toParameterString())
    XCTAssertEqual("Id:lte:test1", BVFilter(filterType: productIdFilterType, filterOperator: lessThanOrEqualToFilterOperator, value: "test1").toParameterString())
    XCTAssertEqual("Id:eq:test1",  BVFilter(filterType: productIdFilterType, filterOperator: equalToFilterOperator, value: "test1").toParameterString())
    XCTAssertEqual("Id:neq:test1", BVFilter(filterType: productIdFilterType, filterOperator: notEqualToFilterOperator, value: "test1").toParameterString())
    
  }
  
  func testTypeStringify() {
    
    let productIdFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productId)
    
    let productAverageOverallRatingFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productAverageOverallRating)
    
    let productCategoryAncestorIdFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productCategoryAncestorId)
    
    let productCategoryIdFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productCategoryId)
    
    let productIsActiveFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productIsActive)
    
    let productIsDisabledFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productIsDisabled)
    
    let productLastAnswerTimeFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productLastAnswerTime)
    
    let productLastQuestionTimeFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productLastQuestionTime)
    
    let productLastReviewTimeFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productLastReviewTime)
    
    let productLastStoryTimeFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productLastStoryTime)
    
    let productNameFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productName)
    
    let productRatingsOnlyReviewCountFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productRatingsOnlyReviewCount)
    
    let productTotalAnswerCountFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productTotalAnswerCount)
    
    let productTotalQuestionCountFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productTotalQuestionCount)
    
    let productTotalReviewCountFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productTotalReviewCount)
    
    let productTotalStoryCountFilterType:BVProductFilterType = BVProductFilterType(productFilterValue: .productTotalStoryCount)
    
    let equalToFilterOperator:BVRelationalFilterOperator =
      BVRelationalFilterOperator(relationalFilterValue: .equalTo)
    
    XCTAssertEqual("Id:eq:val",                      BVFilter(filterType: productIdFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("AverageOverallRating:eq:val",    BVFilter(filterType: productAverageOverallRatingFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("CategoryAncestorId:eq:val",      BVFilter(filterType: productCategoryAncestorIdFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("CategoryId:eq:val",              BVFilter(filterType: productCategoryIdFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("IsActive:eq:val",                BVFilter(filterType: productIsActiveFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("IsDisabled:eq:val",              BVFilter(filterType: productIsDisabledFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("LastAnswerTime:eq:val",          BVFilter(filterType: productLastAnswerTimeFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("LastQuestionTime:eq:val",        BVFilter(filterType: productLastQuestionTimeFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("LastReviewTime:eq:val",          BVFilter(filterType: productLastReviewTimeFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("LastStoryTime:eq:val",           BVFilter(filterType: productLastStoryTimeFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("Name:eq:val",                    BVFilter(filterType: productNameFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("RatingsOnlyReviewCount:eq:val",  BVFilter(filterType: productRatingsOnlyReviewCountFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("TotalAnswerCount:eq:val",        BVFilter(filterType: productTotalAnswerCountFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("TotalQuestionCount:eq:val",      BVFilter(filterType: productTotalQuestionCountFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("TotalReviewCount:eq:val",        BVFilter(filterType: productTotalReviewCountFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    XCTAssertEqual("TotalStoryCount:eq:val",         BVFilter(filterType: productTotalStoryCountFilterType, filterOperator: equalToFilterOperator, value: "val").toParameterString())
    
  }
  
  func testFilterSorting() {
    
    let productIdFilterOperator:BVProductFilterType = BVProductFilterType(productFilterValue: .productId)
    
    let equalToFilterOperator:BVRelationalFilterOperator =
      BVRelationalFilterOperator(relationalFilterValue: .equalTo)
    
    XCTAssertEqual("Id:eq:aaa,bbb,ccc", BVFilter(filterType: productIdFilterOperator, filterOperator: equalToFilterOperator, values: ["aaa", "bbb", "ccc"]).toParameterString())
    XCTAssertEqual("Id:eq:aaa,bbb,ccc", BVFilter(filterType: productIdFilterOperator, filterOperator: equalToFilterOperator, values: ["bbb", "aaa", "ccc"]).toParameterString())
    XCTAssertEqual("Id:eq:aaa,bbb,ccc", BVFilter(filterType: productIdFilterOperator, filterOperator: equalToFilterOperator, values: ["ccc", "bbb", "aaa"]).toParameterString())
    
  }
  
  func testValueEscaping() {
    
    let productIdFilterOperator:BVProductFilterType = BVProductFilterType(productFilterValue: .productId)
    
    let equalToFilterOperator:BVRelationalFilterOperator =
      BVRelationalFilterOperator(relationalFilterValue: .equalTo)
    
    XCTAssertEqual("Id:eq:a\\,a\\:a%26a", BVFilter(filterType: productIdFilterOperator, filterOperator: equalToFilterOperator, value: "a,a:a&a").toParameterString())
    XCTAssertEqual("Id:eq:a\\,aa,b\\:bb,c%26cc", BVFilter(filterType: productIdFilterOperator, filterOperator: equalToFilterOperator, values: ["a,aa", "b:bb", "c&cc"]).toParameterString())
    XCTAssertEqual("Id:eq:a\\,aa,b\\:bb,c%26cc", BVFilter(string: "Id", filterOperator: equalToFilterOperator, values: ["a,aa", "b:bb", "c&cc"]).toParameterString())
  }
  
}

class SortTests: XCTestCase {
  
  func testSimpleSort() {
    let request = BVProductDisplayPageRequest(productId: "test1")
      .include(.pdpReviews, limit: 10)
      .sort(by: .reviewRating, monotonicSortOrderValue: .descending)
    
    let params = request.createParams()
    XCTAssertNotNil(getParamValue(params, keyToSearchFor: "Sort_Reviews"))
    XCTAssertEqual (getParamValue(params, keyToSearchFor: "Sort_Reviews"), "Rating:desc")
  }
  
  func testComplicatedSort() {
    let request = BVProductDisplayPageRequest(productId: "test1")
      .include(.pdpReviews, limit: 10)
      .sort(by: .reviewRating, monotonicSortOrderValue: .descending)
      .sort(by: .reviewSubmissionTime, monotonicSortOrderValue: .descending)
      .sort(by: .questionTotalAnswerCount, monotonicSortOrderValue: .descending)
      .sort(by: .questionTotalFeedbackCount, monotonicSortOrderValue: .ascending)
    
    let params = request.createParams()
    XCTAssertNotNil(getParamValue(params, keyToSearchFor: "Sort_Reviews"))
    XCTAssertEqual (getParamValue(params, keyToSearchFor: "Sort_Reviews"), "Rating:desc,SubmissionTime:desc")
    XCTAssertNotNil(getParamValue(params, keyToSearchFor: "Sort_Questions"))
    XCTAssertEqual (getParamValue(params, keyToSearchFor: "Sort_Questions"), "TotalAnswerCount:desc,TotalFeedbackCount:asc")
  }
  
}
