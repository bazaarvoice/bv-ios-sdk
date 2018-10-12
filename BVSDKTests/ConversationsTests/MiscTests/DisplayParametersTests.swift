//
//  DisplayParametersTests.swift
//  BVSDKTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK


class DisplayParametersTests: XCTestCase {
  
  func testParamsAreSorted() {
    
    let request = BVProductDisplayPageRequest(productId: "test1")
    
    let pdpAnswers:BVInclude = BVInclude(includeType: BVProductIncludeType(pdpIncludeTypeValue: .answers))
    
    let pdpQuestions:BVInclude = BVInclude(includeType: BVProductIncludeType(pdpIncludeTypeValue: .questions))
    
    let pdpReviews:BVInclude = BVInclude(includeType: BVProductIncludeType(pdpIncludeTypeValue: .reviews))
    
    XCTAssertEqual(request.statistics(toParams: [pdpReviews]), "Reviews")
    XCTAssertEqual(request.statistics(toParams: [pdpQuestions]), "Questions")
    XCTAssertEqual(request.statistics(toParams: [pdpAnswers]), "Answers")
    XCTAssertEqual(request.statistics(
      toParams: [pdpReviews, pdpAnswers]), "Answers,Reviews")
    XCTAssertEqual(request.statistics(
      toParams: [pdpQuestions, pdpAnswers]), "Answers,Questions")
    XCTAssertEqual(request.statistics(
      toParams: [pdpReviews, pdpQuestions, pdpAnswers]),
                   "Answers,Questions,Reviews")
    XCTAssertEqual(request.statistics(
      toParams: [pdpAnswers, pdpReviews, pdpQuestions]),
                   "Answers,Questions,Reviews")
  }
  
}
