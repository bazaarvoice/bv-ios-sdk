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
                          "apiKeyConversations": "caaT5bqrrDbwXgbgtR59cHPes3tdfUB4l6DxPpxXAk06g"];
        BVSDKManager.configure(withConfiguration: configDict, configType: .staging)
        BVSDKManager.shared().setLogLevel(.verbose)
    }
    func testSubmitIncrementalReviewSubmission() {
        let agreedtotermsandconditions = true
        let fields: NSDictionary = [
            "mprToken" : "6vsnqsv2l4s3viavkmusz79g3_a81eddb45b298ab3bac20d6e29392bb9902ee1a69cfa4d197d18035c83d949f0",
            "rating" : 5,
            "title" : "This is my favorite product ever!",
            "reviewText" : "This is great its so awesome. I highly recomend using this product and think it makes a great gift for any holiday or special occasion. by far the best purchase ive made this year",
            "agreedtotermsandconditions" : agreedtotermsandconditions
        ]
        let expectation = self.expectation(description: "testSubmitIncrementalReviewSubmission")
        let submission = BVIncrementalReviewSubmission(productId:"product2", submissionFields: fields as! [AnyHashable : Any], userToken: "aa9ee3b1a7cad43c449243b96c920c95245f053215e6b9e75c2645cd0860b3b66d61786167653d333026484f535445443d564552494649454426646174653d323031393033313826656d61696c616464726573733d627674657374757365723833383338334062762e636f6d267573657269643d6c6f63616c2d31353532393338363433323230")
        
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
