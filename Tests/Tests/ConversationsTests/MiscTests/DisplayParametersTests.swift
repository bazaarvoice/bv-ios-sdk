//
//  DisplayParametersTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK


class DisplayParametersTests: XCTestCase {
    
    func testParamsAreSorted() {
        
        let request = BVProductDisplayPageRequest(productId: "test1")
        
        
    
        XCTAssertEqual(request.statistics(toParams: [NSNumber(value:PDPContentType.reviews.rawValue)]), "Reviews")
        XCTAssertEqual(request.statistics(toParams: [NSNumber(value: PDPContentType.questions.rawValue)]), "Questions")
        XCTAssertEqual(request.statistics(toParams: [NSNumber(value: PDPContentType.answers.rawValue)]), "Answers")
        XCTAssertEqual(request.statistics(toParams: [NSNumber(value: PDPContentType.reviews.rawValue), NSNumber(value: PDPContentType.answers.rawValue)]), "Answers,Reviews")
        XCTAssertEqual(request.statistics(toParams: [NSNumber(value: PDPContentType.answers.rawValue), NSNumber(value: PDPContentType.reviews.rawValue)]), "Answers,Reviews")
        XCTAssertEqual(request.statistics(toParams: [NSNumber(value: PDPContentType.reviews.rawValue), NSNumber(value: PDPContentType.answers.rawValue), NSNumber(value: PDPContentType.questions.rawValue)]), "Answers,Questions,Reviews")
        XCTAssertEqual(request.statistics(toParams: [NSNumber(value: PDPContentType.reviews.rawValue), NSNumber(value: PDPContentType.questions.rawValue), NSNumber(value: PDPContentType.answers.rawValue)]), "Answers,Questions,Reviews")
        
    }
    
}
