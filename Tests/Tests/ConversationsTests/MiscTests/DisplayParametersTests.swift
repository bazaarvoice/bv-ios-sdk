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
        
        
        XCTAssertEqual(request.statisticsToParams([PDPContentType.Reviews.rawValue]), "Reviews")
        XCTAssertEqual(request.statisticsToParams([PDPContentType.Questions.rawValue]), "Questions")
        XCTAssertEqual(request.statisticsToParams([PDPContentType.Answers.rawValue]), "Answers")
        XCTAssertEqual(request.statisticsToParams([PDPContentType.Reviews.rawValue, PDPContentType.Answers.rawValue]), "Answers,Reviews")
        XCTAssertEqual(request.statisticsToParams([PDPContentType.Answers.rawValue, PDPContentType.Reviews.rawValue]), "Answers,Reviews")
        XCTAssertEqual(request.statisticsToParams([PDPContentType.Reviews.rawValue, PDPContentType.Answers.rawValue, PDPContentType.Questions.rawValue]), "Answers,Questions,Reviews")
        XCTAssertEqual(request.statisticsToParams([PDPContentType.Reviews.rawValue, PDPContentType.Questions.rawValue, PDPContentType.Answers.rawValue]), "Answers,Questions,Reviews")
        
    }
    
}