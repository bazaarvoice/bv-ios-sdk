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
        
        XCTAssertEqual("Id:gt:test1",  BVFilter(type: .id, filterOperator: .greaterThan, value: "test1").toParameterString())
        XCTAssertEqual("Id:gte:test1", BVFilter(type: .id, filterOperator: .greaterThanOrEqualTo, value: "test1").toParameterString())
        XCTAssertEqual("Id:lt:test1",  BVFilter(type: .id, filterOperator: .lessThan, value: "test1").toParameterString())
        XCTAssertEqual("Id:lte:test1", BVFilter(type: .id, filterOperator: .lessThanOrEqualTo, value: "test1").toParameterString())
        XCTAssertEqual("Id:eq:test1",  BVFilter(type: .id, filterOperator: .equalTo, value: "test1").toParameterString())
        XCTAssertEqual("Id:neq:test1", BVFilter(type: .id, filterOperator: .notEqualTo, value: "test1").toParameterString())
        
    }
    
    func testTypeStringify() {
        
        XCTAssertEqual("Id:eq:val",                      BVFilter(type: .id, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("AverageOverallRating:eq:val",    BVFilter(type: .averageOverallRating, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("CategoryAncestorId:eq:val",      BVFilter(type: .categoryAncestorId, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("CategoryId:eq:val",              BVFilter(type: .categoryId, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("IsActive:eq:val",                BVFilter(type: .isActive, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("IsDisabled:eq:val",              BVFilter(type: .isDisabled, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("LastAnswerTime:eq:val",          BVFilter(type: .lastAnswerTime, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("LastQuestionTime:eq:val",        BVFilter(type: .lastQuestionTime, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("LastReviewTime:eq:val",          BVFilter(type: .lastReviewTime, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("LastStoryTime:eq:val",           BVFilter(type: .lastStoryTime, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("Name:eq:val",                    BVFilter(type: .name, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("RatingsOnlyReviewCount:eq:val",  BVFilter(type: .ratingsOnlyReviewCount, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("TotalAnswerCount:eq:val",        BVFilter(type: .totalAnswerCount, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("TotalQuestionCount:eq:val",      BVFilter(type: .totalQuestionCount, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("TotalReviewCount:eq:val",        BVFilter(type: .totalReviewCount, filterOperator: .equalTo, value: "val").toParameterString())
        XCTAssertEqual("TotalStoryCount:eq:val",         BVFilter(type: .totalStoryCount, filterOperator: .equalTo, value: "val").toParameterString())
        
    }
    
    func testFilterSorting() {
        
        XCTAssertEqual("Id:eq:aaa,bbb,ccc", BVFilter(type: .id, filterOperator: .equalTo, values: ["aaa", "bbb", "ccc"]).toParameterString())
        XCTAssertEqual("Id:eq:aaa,bbb,ccc", BVFilter(type: .id, filterOperator: .equalTo, values: ["bbb", "aaa", "ccc"]).toParameterString())
        XCTAssertEqual("Id:eq:aaa,bbb,ccc", BVFilter(type: .id, filterOperator: .equalTo, values: ["ccc", "bbb", "aaa"]).toParameterString())
        
    }
    
    func testValueEscaping() {
        
        XCTAssertEqual("Id:eq:a\\,a\\:a%26a", BVFilter(type: .id, filterOperator: .equalTo, value: "a,a:a&a").toParameterString())
        XCTAssertEqual("Id:eq:a\\,aa,b\\:bb,c%26cc", BVFilter(type: .id, filterOperator: .equalTo, values: ["a,aa", "b:bb", "c&cc"]).toParameterString())
        XCTAssertEqual("Id:eq:a\\,aa,b\\:bb,c%26cc", BVFilter(string: "Id", filterOperator: .equalTo, values: ["a,aa", "b:bb", "c&cc"]).toParameterString())
        
    }
    
}

class SortTests: XCTestCase {
    
    func testSimpleSort() {
        let request = BVProductDisplayPageRequest(productId: "test1")
            .include(.reviews, limit: 10)
            .sortIncludedReviews(.rating, order: .descending)
        
        let params = request.createParams()
        XCTAssertNotNil(getParamValue(params, keyToSearchFor: "Sort_Reviews"))
        XCTAssertEqual (getParamValue(params, keyToSearchFor: "Sort_Reviews"), "Rating:desc")
    }
    
    func testComplicatedSort() {
        let request = BVProductDisplayPageRequest(productId: "test1")
            .include(.reviews, limit: 10)
            .sortIncludedReviews(.rating, order: .descending)
            .sortIncludedReviews(.submissionTime, order: .descending)
            .sortIncludedQuestions(.totalAnswerCount, order: .descending)
            .sortIncludedQuestions(.totalFeedbackCount, order: .ascending)
        
        let params = request.createParams()
        XCTAssertNotNil(getParamValue(params, keyToSearchFor: "Sort_Reviews"))
        XCTAssertEqual (getParamValue(params, keyToSearchFor: "Sort_Reviews"), "Rating:desc,SubmissionTime:desc")
        XCTAssertNotNil(getParamValue(params, keyToSearchFor: "Sort_Questions"))
        XCTAssertEqual (getParamValue(params, keyToSearchFor: "Sort_Questions"), "TotalAnswerCount:desc,TotalFeedbackCount:asc")
    }
    
}
