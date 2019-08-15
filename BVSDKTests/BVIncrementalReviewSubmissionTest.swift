//
//  BVIncrementalReviewSubmissionTest.swift
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSDK

class BVIncrementalReviewSubmissionTest: XCTestCase {

    override func setUp() {
        super.setUp()
        let configDict = ["clientId": "mpr-testcustomer",
                          "apiKeyConversations": "KEY_REMOVED"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.verbose)
    }
    func testSubmitIncrementalReviewSubmission() {
        let agreedtotermsandconditions = true
        let fields: NSDictionary = [
            "mprToken" : "TOKEN_REMOVED",
            "rating" : 5,
            "title" : "This is my favorite product ever!",
            "reviewText" : "This is great its so awesome. I highly recomend using this product and think it makes a great gift for any holiday or special occasion. by far the best purchase ive made this year",
            "agreedtotermsandconditions" : agreedtotermsandconditions
        ]
        let expectation = self.expectation(description: "testSubmitIncrementalReviewSubmission")
        let submission = BVIncrementalReviewSubmission(productId:"product2", submissionFields: fields as! [AnyHashable : Any], userToken: "TOKEN_REMOVED")
        
        submission.submit({ (submittedReview) in
            expectation.fulfill()
        }, failure: { (errors) in
            expectation.fulfill()
            print(errors)
            XCTFail()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
