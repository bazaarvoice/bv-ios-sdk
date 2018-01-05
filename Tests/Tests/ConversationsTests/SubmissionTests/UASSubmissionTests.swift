//
//  UASSubmissionTests.swift
//  BVSDKTests
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import XCTest
import CommonCrypto
@testable import BVSDK

class UASSubmissionTests: XCTestCase {
    
    fileprivate enum TestStyle {
        case fast
        case slow
    }
    
    fileprivate var testCoverage:TestStyle {
        get {
            return .fast
        }
    }
    
    fileprivate var bvAuthToken:String {
        get {
            // Paste bv_authtoken below:
            return "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        }
    }
    
    override func setUp() {
        super.setUp()
        let configDict =
            ["clientId" : "conversationsapihostedauth",
             "apiKeyConversations" : "KEY_REMOVED"];
        BVSDKManager.configure(
            withConfiguration: configDict, configType: .prod)
        BVSDKManager.shared().setLogLevel(.verbose)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSwapAuthorTokenForUserAuthenticationString() {
        let expectation =
            self.expectation(
                description: "testSwapAuthorTokenForUserAuthenticationString")
        
        // VALIDATE: Please read and/or check this before submitting a SDK release.
        /**
         
         This concerns regression testing against the authenticateuser.json endpoint:
         
         In order to properly validate this test:
         1.) A test review needs to be generated using this conversationsapihostedauth user while also configuring for hosted authentication, i.e., https://developer.bazaarvoice.com/conversations-api/tutorials/submission/authentication/bv-mastered, with valid api parameters, e.g., "hostedauthentication_authenticationemail" and "hostedauthentication_callbackurl". One tip would be to pass a uniquely generated email address with the @mailtest.nexus.bazaarvoice.com prefix domain. Then you can acquire the body of the hosted authentication verification email here: https://s3.console.aws.amazon.com/s3/buckets/notifications-data/openmx/?region=us-east-1
         2.) Find the uniquely generated bitly within the body of the email and copy+paste into your favorite HTTP speaking tool and strip the redirect bv_authtoken parameter out.
         3.) Add that bv_authtoken string to the bvAuthToken computed property of this test.
         4.) Swap the testCoverage computed property to .slow
         5.) Run test(s) and hopefully all succeed.
         
         */
        switch testCoverage {
        case .slow:
            let uasSubmission:BVUASSubmission =
                BVUASSubmission(bvAuthToken: bvAuthToken)
            
            uasSubmission.submit({ (response: BVUASSubmissionResponse) in
                expectation.fulfill()
            }) { (errors:[Error]) in
                
                errors.forEach { print("Expected Failure Item: \($0)") }
                
                XCTFail()
                expectation.fulfill()
            }
            break
        case .fast:
            expectation.fulfill()
            break
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}


