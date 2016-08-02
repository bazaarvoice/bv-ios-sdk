//
//  QuestionDisplayTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class QuestionDisplayTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        
        BVSDKManager.sharedManager().clientId = "apitestcustomer"
        BVSDKManager.sharedManager().apiKeyConversations = "kuy3zj9pr3n7i0wxajrzj04xo"
        BVSDKManager.sharedManager().staging = true
    }
    
    
    func testQuestionDisplay() {
        
        let expectation = expectationWithDescription("")
        
        let request = BVQuestionsAndAnswersRequest(productId: "test1", limit: 10, offset: 0)
            .addFilter(.HasAnswers, filterOperator: .EqualTo, value: "true")
        
        request.load({ (response) in
            
            XCTAssertEqual(response.results.count, 10)
            
            let question = response.results.first!
            XCTAssertEqual(question.questionSummary, "Das ist mein test :)")
            XCTAssertEqual(question.questionDetails, "Das ist mein test :)")
            XCTAssertEqual(question.userNickname, "123thisisme")
            XCTAssertEqual(question.authorId, "eplz083100g")
            XCTAssertEqual(question.moderationStatus, "APPROVED")
            XCTAssertEqual(question.identifier, "14828")
            
            XCTAssertEqual(question.answers.count, 1)
            
            let answer = question.answers.first!
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
            
        }
        
        self.waitForExpectationsWithTimeout(10) { (error) in print("request took way too long") }
        
    }
    
}