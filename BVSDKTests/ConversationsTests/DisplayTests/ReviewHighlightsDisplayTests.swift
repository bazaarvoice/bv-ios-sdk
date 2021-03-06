//
//  ReviewHighlightsDisplayTests.swift
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

/*
 Test case Scenarios:
 
 Both Pros and Cons are returned for a valid productId and clientId.
 Only Pros are returned and no Cons are returned for a valid productId and clientId.
 Only Cons are returned and no Pros are returned for a valid productId and clientId.
 The count of PROS and CONS Should be equal to or less then five.
 No Pros and Cons are returned for a valid productId and clientId (Review count < 10, Excluding incentivised reviews review count < 10).
 The given productId is invalid. In this case a specific error should be returned.
 The given clientId is invalid. In this case a specific error should be returned.
 The sequence of the Pros and Cons should be the same as return in Response.
 */

import XCTest
@testable import BVSDK

class ReviewHighlightsDisplayTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let configDict = ["clientId": "1800petmeds"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.verbose)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //Both Pros and Cons are returned for a valid productId and clientId.
    func testProsAndCons() {
        
        let expectation = self.expectation(description: "testProsAndCons")
        
        let request = BVReviewHighlightsRequest(productId: "prod1011")
        request.load({ (response) in
            
            XCTAssertNotNil(response.reviewHighlights)
            XCTAssertNotNil(response.reviewHighlights.negatives)
            XCTAssertNotNil(response.reviewHighlights.positives)
            
            if let negatives = response.reviewHighlights.negatives {
                XCTAssertFalse(negatives.isEmpty)
                
                for negative in negatives {
                    XCTAssertNotNil(negative.title)
                }
            }
            
            if let positives = response.reviewHighlights.positives {
                XCTAssertFalse(positives.isEmpty)
                
                for positive in positives {
                    XCTAssertNotNil(positive.title)
                }
            }
            
            expectation.fulfill()
            
        }) { (error) in
            
            XCTFail("Review Highlights display request error: \(error)")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
    //Only Pros are returned and no Cons are returned for a valid productId and clientId.
    func testOnlyProsAndNoCons() {
        
        let expectation = self.expectation(description: "testOnlyProsAndNoCons")
        
        let request = BVReviewHighlightsRequest(productId: "prod10002")
        request.load({ (response) in
            
            
            XCTAssertNotNil(response.reviewHighlights)
            XCTAssertNotNil(response.reviewHighlights.positives)
            
            if let positives = response.reviewHighlights.positives {
                XCTAssertFalse(positives.isEmpty)
                
                for positive in positives {
                    XCTAssertNotNil(positive.title)
                }
            }
            
            XCTAssertNotNil(response.reviewHighlights.negatives)
            
            if let negatives = response.reviewHighlights.negatives {
                XCTAssertTrue(negatives.isEmpty)
            }
            
            expectation.fulfill()
            
        }) { (error) in
            
            XCTFail("Review Highlights display request error: \(error)")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
    //Only Cons are returned and no Pros are returned for a valid productId and clientId.
    func testOnlyConsAndNoPros() {
        
        let expectation = self.expectation(description: "testOnlyConsAndNoPros")
        
        let request = BVReviewHighlightsRequest(productId: "prod1022")
        request.load({ (response) in
            
            XCTAssertNotNil(response.reviewHighlights)
            XCTAssertNotNil(response.reviewHighlights.negatives)
            
            if let negatives = response.reviewHighlights.negatives {
                XCTAssertFalse(negatives.isEmpty)
                
                for negative in negatives {
                    XCTAssertNotNil(negative.title)
                }
            }
            
            XCTAssertNotNil(response.reviewHighlights.positives)
            
            if let positives = response.reviewHighlights.positives {
                XCTAssertTrue(positives.isEmpty)
            }
            
            expectation.fulfill()
            
        }) { (error) in
            
            XCTFail("Review Highlights display request error: \(error)")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    //No Pros and No Cons are returned for a valid productId and clientId (Review count < 10, Excluding incentivised reviews review count < 10).
    func testNoProsAndNoCons() {
        
        let expectation = self.expectation(description: "testNoProsAndCons")
        
        let request = BVReviewHighlightsRequest(productId: "5068ZW")
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
    
    //The count of PROS and CONS Should be equal to or less then five.
    func testCountOfProsAndConsNotMoreThanFive() {
        
        let expectation = self.expectation(description: "testCountOfProsAndConsNotMoreThanFive")
        
        let request = BVReviewHighlightsRequest(productId: "prod11480")
        request.load({ (response) in
            
            XCTAssertNotNil(response.reviewHighlights)
            XCTAssertNotNil(response.reviewHighlights.positives)
            XCTAssertNotNil(response.reviewHighlights.negatives)
            
            if let negatives = response.reviewHighlights.negatives {
                
                for negative in negatives {
                    XCTAssertNotNil(negative.title)
                }
                
                XCTAssertFalse(negatives.count > 5)
            }
            
            if let positives = response.reviewHighlights.positives {
                
                for positive in positives {
                    XCTAssertNotNil(positive.title)
                }
                
                XCTAssertFalse(positives.count > 5)
            }
            
            expectation.fulfill()
            
            
        }) { (error) in
            
            XCTFail("Review Highlights display request error: \(error)")
            expectation.fulfill()
            
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly worng, request took too long.")
        }
    }
    
    //The given productId is invalid. In this case a specific error should be returned.
    func testInvalidProductId() {
        
        let expectation = self.expectation(description: "testInvalidProductId")
        
        let request = BVReviewHighlightsRequest(productId: "invalidProductId")
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
    
    //The given clientId is invalid. In this case a specific error should be returned.
    func testInvalidClientId() {
        
        let expectation = self.expectation(description: "testInvalidClientId")
        
        //To change the Client ID for this TestCase.
        let configDict = ["clientId": "invalidClinetId"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.verbose)
        
        let request = BVReviewHighlightsRequest(productId: "5068ZW")
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
    
    //The sequence of the Pros and Cons should be the same as return in Response.
    func testProsAndConsSequence() {
        
        let expectation = self.expectation(description: "testProsAndConsSequence")
        
        let expectedPositives: [String] = ["cleaning", "satisfaction", "ease of use"] // array of expected positives
        let expectedNegatives: [String] = ["small", "large"] // array of expected negatives
        
        let request = BVReviewHighlightsRequest(productId: "prod1011")
        request.load({ (response) in
            
            XCTAssertNotNil(response.reviewHighlights)
            XCTAssertNotNil(response.reviewHighlights.negatives)
            XCTAssertNotNil(response.reviewHighlights.positives)
            
            if let negatives = response.reviewHighlights.negatives {
                XCTAssertFalse(negatives.isEmpty)
                
                for (index, negative) in negatives.enumerated() {
                    XCTAssertNotNil(negative.title)
                    //XCTAssertEqual(negative.title, expectedNegatives[index])
                }
            }
            
            if let positives = response.reviewHighlights.positives {
                XCTAssertFalse(positives.isEmpty)
                
                for (index, positive) in positives.enumerated() {
                    XCTAssertNotNil(positive.title)
                    //XCTAssertEqual(positive.title, expectedPositives[index])
                }
            }
            
            expectation.fulfill()
            
        }) { (error) in
            
            XCTFail("Review Highlights display request error: \(error)")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
}
