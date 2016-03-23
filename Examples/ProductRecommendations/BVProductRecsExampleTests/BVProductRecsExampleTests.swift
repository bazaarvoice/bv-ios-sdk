//
//  BVProductRecsExampleTests.swift
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

import XCTest
import BVSDK

class BVProductRecsExampleTests: XCTestCase {
    
    override func setUp() {
        
        BVSDKManager.sharedManager().staging = true;
        
    }

    
    func testSdkErrorsWithBadClientId() {
        
        // check that SDK fails when clientId is empty
        
        BVSDKManager.sharedManager().clientId = ""
        BVSDKManager.sharedManager().apiKeyShopperAdvertising = "fakeKey"
        
        let request = BVRecommendationsRequest(limit: 20)
        let loader = BVRecommendationsLoader()
        loader.loadRequest(request, completionHandler: { (recommendations:[BVProduct]) in
            
            XCTFail("BVRecommendationsLoader should have called the error handler.")
            
        }) { (error:NSError) in
            
            // yay!
            
        }
        
    }
    
    func testSdkErrorsWithBadShopperAdvertisingPassKey() {
        
        // check that SDK fails when clientId is empty
        
        BVSDKManager.sharedManager().clientId = "fakeClient"
        BVSDKManager.sharedManager().apiKeyShopperAdvertising = ""
        
        let request = BVRecommendationsRequest(limit: 20)
        let loader = BVRecommendationsLoader()
        loader.loadRequest(request, completionHandler: { (recommendations:[BVProduct]) in
            
            XCTFail("BVRecommendationsLoader should have called the error handler.")
            
        }) { (error:NSError) in
            
            // yay!
            
        }
        
    }
    
    func testSdkErrorsWithBadClientIdAndShopperAdvertisingPassKey() {
        
        // check that SDK fails when clientId is empty
        
        BVSDKManager.sharedManager().clientId = ""
        BVSDKManager.sharedManager().apiKeyShopperAdvertising = ""
        
        let request = BVRecommendationsRequest(limit: 20)
        let loader = BVRecommendationsLoader()
        loader.loadRequest(request, completionHandler: { (recommendations:[BVProduct]) in
            
            XCTFail("BVRecommendationsLoader should have called the error handler.")
            
        }) { (error:NSError) in
            
            // yay!
            
        }
        
    }
    
}

