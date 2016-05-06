//
//  File.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import Foundation
import OHHTTPStubs
import SwiftyJSON
import BVSDK

class MockDataManager {
    
    static let sharedInstance = MockDataManager()
    
    init() {
        self.setupPreSelectedKeysIfPresent()
        self.setupMocking()
    }
    
    static let PRESELECTED_CONFIG_DISPLAY_NAME_KEY = "BV_PRE_SELECTED_CONFIG_DISPLAY_NAME"
    
    func setupPreSelectedKeysIfPresent() {
        
        let defaults = NSUserDefaults(suiteName: "group.bazaarvoice.bvsdkdemo")
        
        guard let demoConfigs = DemoConfigManager.configs else { return }
        guard let preselectedDisplayName = defaults!.stringForKey(MockDataManager.PRESELECTED_CONFIG_DISPLAY_NAME_KEY) else { return }
        
        let matchingConfig = demoConfigs.filter{ $0.displayName == preselectedDisplayName }.first
        
        if matchingConfig != nil {
            BVSDKManager.sharedManager().clientId = matchingConfig!.clientId
            BVSDKManager.sharedManager().apiKeyCurations = matchingConfig!.curationsKey
            BVSDKManager.sharedManager().apiKeyConversations = matchingConfig!.conversationsKey
            BVSDKManager.sharedManager().apiKeyShopperAdvertising = matchingConfig!.shopperAdvertisingKey
        }
        
    }
    
    func setupMocking() {
        
        OHHTTPStubs.stubRequestsPassingTest({ (request) -> Bool in
            
            return self.shouldMockResponseForRequest(request)
            
        }) { (request) -> OHHTTPStubsResponse in
            
            return self.resposneForRequest(request)
            
        }
        
    }
    
    let curationsUrlMatch = "bazaarvoice.com/curations/content/get"
    let curationsPhotoPostUrlMatch = "https://api.bazaarvoice.com/curations/content/add/"
    let recommendationsUrlMatch = "bazaarvoice.com/recommendations"
    let profileUrlMatch = "bazaarvoice.com/users"
    let analyticsMatch = "bazaarvoice.com/event"
    let conversationsMatch = "bazaarvoice.com/data/reviews"
    let conversationsQuestionsMatch = "bazaarvoice.com/data/question"
    let conversationsProductMatch = "bazaarvoice.com/data/products"
    let submitReviewMatch = "bazaarvoice.com/data/submitreview"
    let submitReviewPhotoMatch = "bazaarvoice.com/data/uploadphoto"
    let submitQuestionMatch = "bazaarvoice.com/data/submitquestion"
    let submitAnswerMatch = "bazaarvoice.com/data/submitanswer"
    
    func shouldMockResponseForRequest(request: NSURLRequest) -> Bool {
        
        guard let url = request.URL?.absoluteString else {
            return false
        }
        
        return self.shouldMockData() && (self.isAnalyticsRequest(url) || self.isSdkRequest(url));
        
    }
    
    func isAnalyticsRequest(url: String) -> Bool {
        
        return url.containsString(analyticsMatch)
        
    }
    
    func isSdkRequest(url: String) -> Bool {
        
        let containsCurations = url.containsString(curationsUrlMatch)
        let containsCurationsPhotoPost = url.containsString(curationsPhotoPostUrlMatch)
        let containsProfile = url.containsString(profileUrlMatch)
        let containsRecommendations = url.containsString(recommendationsUrlMatch)
        let containsConversations = url.containsString(conversationsMatch)
        let containsConversationsQuestions = url.containsString(conversationsQuestionsMatch)
        let containsConversationsProducts = url.containsString(conversationsProductMatch)
        let containsSubmitReviews = url.containsString(submitReviewMatch)
        let containsSubmitPhotoReviews = url.containsString(submitReviewPhotoMatch)
        let containsSubmitQuestion = url.containsString(submitQuestionMatch)
        let containsSubmitAnswers = url.containsString(submitAnswerMatch)
        
        return containsCurations || containsCurationsPhotoPost || containsRecommendations || containsProfile || containsConversations || containsConversationsQuestions || containsConversationsProducts || containsSubmitReviews || containsSubmitPhotoReviews || containsSubmitQuestion || containsSubmitAnswers
        
    }
    
    func shouldMockData() -> Bool {
        
        let manager = BVSDKManager.sharedManager()
        
        return manager.apiKeyCurations == "REPLACE_ME"
            && manager.apiKeyConversations == "REPLACE_ME"
            && manager.apiKeyShopperAdvertising == "REPLACE_ME"
        
    }
    
    
    
    let headers = ["Content-Type": "application/json"]
    
    func resposneForRequest(request: NSURLRequest) -> OHHTTPStubsResponse {
        
        print("Mocking request: \(request.URL!.absoluteString)")
        
        guard let url = request.URL?.absoluteString else {
            return OHHTTPStubsResponse()
        }
        
        if self.isAnalyticsRequest(url) {
            return self.responseForAnalyticsRequest(url)
        }
        else if self.isSdkRequest(url) {
            return self.responseForSdkRequest(url)
        }
        
        return OHHTTPStubsResponse()
        
    }
    
    func responseForAnalyticsRequest(url: String) -> OHHTTPStubsResponse {
        
        return OHHTTPStubsResponse(
            data: NSData(),
            statusCode: 200,
            headers: nil
        )
        
    }
    
    func responseForSdkRequest(url: String) -> OHHTTPStubsResponse {
        
        if url.containsString(curationsUrlMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("curationsEnduranceCycles.json", self.dynamicType)!,
                statusCode: 200,
                headers: headers
            )
            
        }
        
        if url.containsString(curationsPhotoPostUrlMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("post_successfulCreation.json", self.dynamicType)!,
                statusCode: 200,
                headers: headers
            )
            
        }

        
        if url.containsString(recommendationsUrlMatch) {
            
            return OHHTTPStubsResponse(
                JSONObject: generateRecommendationsResponseDictionary(),
                statusCode: 200,
                headers: headers
            )
            
        }
        
        if url.containsString(profileUrlMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("userProfile1.json", self.dynamicType)!,
                statusCode: 200,
                headers: headers
            )
            
        }
        
        if url.containsString(conversationsMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("conversationsReviewsEnduranceCycles.json", self.dynamicType)!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.containsString(conversationsQuestionsMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("conversationsQuestionsIncludeAnswers.json", self.dynamicType)!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.containsString(conversationsProductMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("conversationsProductsIncludeStats.json", self.dynamicType)!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.containsString(submitReviewMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("submitReview.json", self.dynamicType)!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.containsString(submitReviewPhotoMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("submitPhotoWithReview.json", self.dynamicType)!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.containsString(submitQuestionMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("submitQuestion.json", self.dynamicType)!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.containsString(submitAnswerMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("submitAnswer.json", self.dynamicType)!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        return OHHTTPStubsResponse()
        
    }
    
    /// randomize the recommendations in JSON file for variation between loads.
    func generateRecommendationsResponseDictionary() -> [String: AnyObject] {
        
        guard let path = NSBundle.mainBundle().pathForResource("recommendationsResult", ofType: "json") else {
            print("Invalid filename/path.")
            return [:]
        }
        
        do {
            let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
            var json = JSON(data: data)
            
            let recommendations:[String] = json["profile"]["recommendations"].arrayValue.map { $0.string!}
            // randomize order
            let shuffledRecommendations = recommendations.sort() {_, _ in arc4random() % 2 == 0}
            json["profile"]["recommendations"] = JSON(shuffledRecommendations)
            
            return json.dictionaryObject!
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return [:]
        
    }
    
}

class DemoConfigManager {
    
    
    static let configs : [DemoConfig]? = {
        
        guard let path = NSBundle.mainBundle().pathForResource("config/DemoAppConfigs", ofType: "plist") else { return nil }
        guard let contents = NSArray(contentsOfFile: path) else { return nil }
        
        return contents.map{ DemoConfig(dictionary: $0 as! NSDictionary) }
        
    }()
    
}

class DemoConfig {
    
    let clientId, displayName, curationsKey, conversationsKey, shopperAdvertisingKey : String
    
    init(dictionary:NSDictionary) {
        
        clientId = dictionary["clientId"] as! String
        displayName = dictionary["displayName"] as! String
        curationsKey = dictionary["apiKeyCurations"] as! String
        conversationsKey = dictionary["apiKeyConversations"] as! String
        shopperAdvertisingKey = dictionary["apiKeyShopperAdvertising"] as! String
        
    }
}