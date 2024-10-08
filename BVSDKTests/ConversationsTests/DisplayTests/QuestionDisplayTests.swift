//
//  QuestionDisplayTests.swift
//  BVSDKTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSDK

class QuestionDisplayTests: XCTestCase {
  
  
  override func setUp() {
    super.setUp()
    
    let configDict = ["clientId": "apitestcustomer",
                      "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey1)];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
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
      XCTAssertEqual(answer.brandImageLogoURL, nil)
      XCTAssertEqual(answer.answerText, "zxnc,vznxc osaidmf oaismdfo ims adoifmaosidmfoiamsdfimasdf")
      
        response.results.forEach { _ in (question) 
        XCTAssertEqual(question.productId, "test1")
      }
      
      expectation.fulfill()
      
    }) { (error) in
      
      XCTFail("product display request error: \(error)")
      
    }
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
    
  }
  
    
    func testQuestionDisplayLimitFailure() {
        
        let expectation = self.expectation(description: "testQuestionDisplayFailure")
        
        let request = BVQuestionsAndAnswersRequest(productId: "test1", limit: 101, offset: 0)
            .filter(on: .questionHasAnswers, relationalFilterOperatorValue: .equalTo, value: "true")
        
        request.load({ (response) in
            
            XCTFail("success block should not be called")
            
            expectation.fulfill()
            
        }) { (error) in
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
            
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
  func testQuestionDisplayCOR() {
    
    let configDict = ["clientId": "testcust-contentoriginsynd",
                      "apiKeyConversations": BVTestUsers().loadValueForKey(key: .conversationsKey2)];
    BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
    
    let expectation = self.expectation(description: "testQuestionDisplayCOR")
    let request = BVQuestionsAndAnswersRequest(productId: "Concierge-Common-Product-1", limit: 10, offset: 0)
      .filter(on: .questionHasAnswers, relationalFilterOperatorValue: .equalTo, value: "true")
    
    request.load({ (response) in
      
      guard let question : BVQuestion = response.results.first(where: { $0.identifier == "1536656" }) else {
        
        XCTFail("question not found")
        expectation.fulfill()
        return
        
      }
      //Source Client
      XCTAssertEqual(question.sourceClient, "testcust-contentorigin")
      //Syndicated Source
      XCTAssertNotNil(question.syndicationSource)
      XCTAssertEqual(question.syndicationSource?.logoImageUrl, "https://contentorigin-stg.bazaarvoice.com/testsynd-origin/en_US/SYND1_SKY.png")
      XCTAssertEqual(question.syndicationSource?.name, "TestCustomer-Contentorigin_Synd_en_US")
      
     
      
      guard let answer : BVAnswer = question.includedAnswers.first(where: { $0.identifier == "1577185" }) else {
        
        XCTFail("answer not found")
        expectation.fulfill()
        return
        
      }
      //Source Client
      XCTAssertEqual(answer.sourceClient, "testcust-contentorigin")
      //Syndicated Source
      XCTAssertNotNil(answer.syndicationSource)
      XCTAssertEqual(answer.syndicationSource?.logoImageUrl, "https://contentorigin-stg.bazaarvoice.com/testsynd-origin/en_US/SYND1_SKY.png")
      XCTAssertEqual(answer.syndicationSource?.name, "TestCustomer-Contentorigin_Synd_en_US")
      
      expectation.fulfill()
      
    }) { (error) in
      
      XCTFail("question display request error: \(error)")
      
    }
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(error, "Something went horribly wrong, request took too long.")
    }
  }
}
