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
        
        XCTAssertEqual("Id:gt:test1",  BVFilter(type: .Id, filterOperator: .GreaterThan, value: "test1").toParameterString())
        XCTAssertEqual("Id:gte:test1", BVFilter(type: .Id, filterOperator: .GreaterThanOrEqualTo, value: "test1").toParameterString())
        XCTAssertEqual("Id:lt:test1",  BVFilter(type: .Id, filterOperator: .LessThan, value: "test1").toParameterString())
        XCTAssertEqual("Id:lte:test1", BVFilter(type: .Id, filterOperator: .LessThanOrEqualTo, value: "test1").toParameterString())
        XCTAssertEqual("Id:eq:test1",  BVFilter(type: .Id, filterOperator: .EqualTo, value: "test1").toParameterString())
        XCTAssertEqual("Id:neq:test1", BVFilter(type: .Id, filterOperator: .NotEqualTo, value: "test1").toParameterString())
        
    }
    
    func testTypeStringify() {
        
        XCTAssertEqual("Id:eq:val",                      BVFilter(type: .Id, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("AverageOverallRating:eq:val",    BVFilter(type: .AverageOverallRating, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("CategoryAncestorId:eq:val",      BVFilter(type: .CategoryAncestorId, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("CategoryId:eq:val",              BVFilter(type: .CategoryId, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("IsActive:eq:val",                BVFilter(type: .IsActive, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("IsDisabled:eq:val",              BVFilter(type: .IsDisabled, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("LastAnswerTime:eq:val",          BVFilter(type: .LastAnswerTime, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("LastQuestionTime:eq:val",        BVFilter(type: .LastQuestionTime, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("LastReviewTime:eq:val",          BVFilter(type: .LastReviewTime, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("LastStoryTime:eq:val",           BVFilter(type: .LastStoryTime, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("Name:eq:val",                    BVFilter(type: .Name, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("RatingsOnlyReviewCount:eq:val",  BVFilter(type: .RatingsOnlyReviewCount, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("TotalAnswerCount:eq:val",        BVFilter(type: .TotalAnswerCount, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("TotalQuestionCount:eq:val",      BVFilter(type: .TotalQuestionCount, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("TotalReviewCount:eq:val",        BVFilter(type: .TotalReviewCount, filterOperator: .EqualTo, value: "val").toParameterString())
        XCTAssertEqual("TotalStoryCount:eq:val",         BVFilter(type: .TotalStoryCount, filterOperator: .EqualTo, value: "val").toParameterString())
        
    }
    
    func testFilterSorting() {
        
        XCTAssertEqual("Id:eq:aaa,bbb,ccc", BVFilter(type: .Id, filterOperator: .EqualTo, values: ["aaa", "bbb", "ccc"]).toParameterString())
        XCTAssertEqual("Id:eq:aaa,bbb,ccc", BVFilter(type: .Id, filterOperator: .EqualTo, values: ["bbb", "aaa", "ccc"]).toParameterString())
        XCTAssertEqual("Id:eq:aaa,bbb,ccc", BVFilter(type: .Id, filterOperator: .EqualTo, values: ["ccc", "bbb", "aaa"]).toParameterString())
        
    }
    
    func testValueEscaping() {
        
        XCTAssertEqual("Id:eq:a\\,a\\:a%26a", BVFilter(type: .Id, filterOperator: .EqualTo, value: "a,a:a&a").toParameterString())
        XCTAssertEqual("Id:eq:a\\,aa,b\\:bb,c%26cc", BVFilter(type: .Id, filterOperator: .EqualTo, values: ["a,aa", "b:bb", "c&cc"]).toParameterString())
        XCTAssertEqual("Id:eq:a\\,aa,b\\:bb,c%26cc", BVFilter(string: "Id", filterOperator: .EqualTo, values: ["a,aa", "b:bb", "c&cc"]).toParameterString())
        
    }
    
}

class SortTests: XCTestCase {
    
    func testSimpleSort() {
        let request = BVProductDisplayPageRequest(productId: "test1")
            .includeContent(.Reviews, limit: 10)
            .sortIncludedReviews(.Rating, order: .Descending)
        
        let params = request.createParams()
        XCTAssertNotNil(getParamValue(params, keyToSearchFor: "Sort_Reviews"))
        XCTAssertEqual (getParamValue(params, keyToSearchFor: "Sort_Reviews"), "Rating:desc")
    }
    
    func testComplicatedSort() {
        let request = BVProductDisplayPageRequest(productId: "test1")
            .includeContent(.Reviews, limit: 10)
            .sortIncludedReviews(.Rating, order: .Descending)
            .sortIncludedReviews(.SubmissionTime, order: .Descending)
            .sortIncludedQuestions(.TotalAnswerCount, order: .Descending)
            .sortIncludedQuestions(.TotalFeedbackCount, order: .Ascending)
        
        let params = request.createParams()
        XCTAssertNotNil(getParamValue(params, keyToSearchFor: "Sort_Reviews"))
        XCTAssertEqual (getParamValue(params, keyToSearchFor: "Sort_Reviews"), "Rating:desc,SubmissionTime:desc")
        XCTAssertNotNil(getParamValue(params, keyToSearchFor: "Sort_Questions"))
        XCTAssertEqual (getParamValue(params, keyToSearchFor: "Sort_Questions"), "TotalAnswerCount:desc,TotalFeedbackCount:asc")
    }
    
}