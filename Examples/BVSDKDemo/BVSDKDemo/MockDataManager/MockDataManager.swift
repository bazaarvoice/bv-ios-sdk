//
//  MockDataManager.swift
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
        
        let defaults = UserDefaults(suiteName: "group.bazaarvoice.bvsdkdemo.app")
        
        guard let demoConfigs = DemoConfigManager.configs else { return }
        guard let preselectedDisplayName = defaults!.string(forKey: MockDataManager.PRESELECTED_CONFIG_DISPLAY_NAME_KEY) else { return }
        
        let matchingConfig = demoConfigs.filter{ $0.displayName == preselectedDisplayName }.first
        
        if matchingConfig != nil {
            BVSDKManager.shared().clientId = matchingConfig!.clientId
            BVSDKManager.shared().apiKeyCurations = matchingConfig!.curationsKey
            BVSDKManager.shared().apiKeyConversations = matchingConfig!.conversationsKey
            BVSDKManager.shared().apiKeyConversationsStores = matchingConfig!.conversationsStoresKey
            BVSDKManager.shared().apiKeyShopperAdvertising = matchingConfig!.shopperAdvertisingKey
            BVSDKManager.shared().apiKeyLocation = matchingConfig!.locationKey
        }
        
    }
    
    func setupMocking() {
        
        OHHTTPStubs.stubRequests(passingTest: { (request) -> Bool in
            
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
    let notificationConfigMatch = "s3.amazonaws.com/incubator-mobile-apps/conversations-stores"
    
    func shouldMockResponseForRequest(_ request: URLRequest) -> Bool {
        
        guard let url = request.url?.absoluteString else {
            return false
        }
        
        return self.shouldMockData() && (self.isAnalyticsRequest(url) || self.isSdkRequest(url));
        
    }
    
    func isAnalyticsRequest(_ url: String) -> Bool {
        
        return url.contains(analyticsMatch)
        
    }
    
    func isSdkRequest(_ url: String) -> Bool {
        
        let containsCurations = url.contains(curationsUrlMatch)
        let containsCurationsPhotoPost = url.contains(curationsPhotoPostUrlMatch)
        let containsProfile = url.contains(profileUrlMatch)
        let containsRecommendations = url.contains(recommendationsUrlMatch)
        let containsConversations = url.contains(conversationsMatch)
        let containsConversationsQuestions = url.contains(conversationsQuestionsMatch)
        let containsConversationsProducts = url.contains(conversationsProductMatch)
        let containsSubmitReviews = url.contains(submitReviewMatch)
        let containsSubmitPhotoReviews = url.contains(submitReviewPhotoMatch)
        let containsSubmitQuestion = url.contains(submitQuestionMatch)
        let containsSubmitAnswers = url.contains(submitAnswerMatch)
        let notificationConfig = url.contains(notificationConfigMatch)
        
        return containsCurations || containsCurationsPhotoPost || containsRecommendations || containsProfile || containsConversations || containsConversationsQuestions || containsConversationsProducts || containsSubmitReviews || containsSubmitPhotoReviews || containsSubmitQuestion || containsSubmitAnswers || notificationConfig
        
    }
    
    func shouldMockData() -> Bool {
        
        let manager = BVSDKManager.shared()
        
        return manager.apiKeyCurations == "REPLACE_ME"
            && manager.apiKeyConversations == "REPLACE_ME"
            && manager.apiKeyConversationsStores == "REPLACE_ME"
            && manager.apiKeyShopperAdvertising == "REPLACE_ME"
    }
    
    let headers = ["Content-Type": "application/json"]
    
    func resposneForRequest(_ request: URLRequest) -> OHHTTPStubsResponse {
        
        print("Mocking request: \(request.url!.absoluteString)")
        
        guard let url = request.url?.absoluteString else {
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
    
    func responseForAnalyticsRequest(_ url: String) -> OHHTTPStubsResponse {
        
        return OHHTTPStubsResponse(
            data: Data(),
            statusCode: 200,
            headers: nil
        )
        
    }
    
    func responseForSdkRequest(_ url: String) -> OHHTTPStubsResponse {
        
        if url.contains(curationsUrlMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("curationsEnduranceCycles.json", type(of: self))!,
                statusCode: 200,
                headers: headers
            )
            
        }
        
        if url.contains(curationsPhotoPostUrlMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("post_successfulCreation.json", type(of: self))!,
                statusCode: 200,
                headers: headers
            )
            
        }

        
        if url.contains(recommendationsUrlMatch) {
            
            return OHHTTPStubsResponse(
                jsonObject: generateRecommendationsResponseDictionary(),
                statusCode: 200,
                headers: headers
            )
            
        }
        
        if url.contains(profileUrlMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("userProfile1.json", type(of: self))!,
                statusCode: 200,
                headers: headers
            )
            
        }
        
        if url.contains(conversationsMatch) {
            
            // Conversations requests will vary depending on parameters
            // Hence check for specific parameters to set mock results.
            
            var conversationsReviewsResultMockFile = "conversationsReviewsEnduranceCycles.json" // default, sorted by most recent
            
            if url.contains("Sort=Rating:desc"){
                conversationsReviewsResultMockFile = "conversationsReviewsEnduranceCycles_SortHighestRated.json"
            } else if url.contains("Sort=Rating:asc"){
                conversationsReviewsResultMockFile = "conversationsReviewsEnduranceCycles_SortLowestRated.json"
            } else if url.contains("Sort=Helpfulness:desc"){
                conversationsReviewsResultMockFile = "conversationsReviewsEnduranceCycles_SortMostHelpful.json"
            } else if url.contains("UserLocation:eq"){
                conversationsReviewsResultMockFile = "conversationsReviewsEnduranceCycles_FilterLocation.json"
            }
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile(conversationsReviewsResultMockFile, type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.contains(conversationsQuestionsMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("conversationsQuestionsIncludeAnswers.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.contains(conversationsProductMatch) {
            
            // In the demp app, when requesting product status we just use the Filter=Id:eq:<id> param
            // When we request a store list, we use the Offset parameter. 
            // So we'll use that info
            if url.contains("Offset=0"){
            
                return OHHTTPStubsResponse(
                    fileAtPath: OHPathForFile("storeBulkFeedWithStatistics.json", type(of: self))!,
                    statusCode: 200,
                    headers: ["Content-Type": "application/json;charset=utf-8"]
                )
                
            } else {
            
                return OHHTTPStubsResponse(
                    fileAtPath: OHPathForFile("conversationsProductsIncludeStats.json", type(of: self))!,
                    statusCode: 200,
                    headers: ["Content-Type": "application/json;charset=utf-8"]
                )
            
            }
            
        }
        
        if url.contains(submitReviewMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("submitReview.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.contains(submitReviewPhotoMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("submitPhotoWithReview.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.contains(submitQuestionMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("submitQuestion.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.contains(submitAnswerMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("submitAnswer.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.contains(notificationConfigMatch) {
            
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("testNotificationConfig.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }

        
        return OHHTTPStubsResponse()
        
    }
    
    /// randomize the recommendations in JSON file for variation between loads.
    func generateRecommendationsResponseDictionary() -> [String: AnyObject] {
        
        guard let path = Bundle.main.path(forResource: "recommendationsResult", ofType: "json") else {
            print("Invalid filename/path.")
            return [:]
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
            var json = JSON(data: data)
            
            let recommendations:[String] = json["profile"]["recommendations"].arrayValue.map { $0.string!}
            // randomize order
            let shuffledRecommendations = recommendations.sorted() {_, _ in arc4random() % 2 == 0}
            json["profile"]["recommendations"] = JSON(shuffledRecommendations)
            
            return json.dictionaryObject! as [String : AnyObject]
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return [:]
        
    }
    
}

class DemoConfigManager {
    
    
    static let configs : [DemoConfig]? = {
        
        guard let path = Bundle.main.path(forResource: "config/DemoAppConfigs", ofType: "plist") else { return nil }
        guard let contents = NSArray(contentsOfFile: path) else { return nil }
        
        return contents.map{ DemoConfig(dictionary: $0 as! NSDictionary) }
        
    }()
    
}

class DemoConfig {
    
    let clientId, displayName, curationsKey, conversationsKey, conversationsStoresKey, shopperAdvertisingKey, locationKey : String
    
    init(dictionary:NSDictionary) {
        
        clientId = dictionary["clientId"] as! String
        displayName = dictionary["displayName"] as! String
        curationsKey = dictionary["apiKeyCurations"] as! String
        conversationsKey = dictionary["apiKeyConversations"] as! String
        conversationsStoresKey = dictionary["apiKeyConversationsStores"] as! String
        shopperAdvertisingKey = dictionary["apiKeyShopperAdvertising"] as! String
        locationKey = dictionary["apiKeyLocation"] as! String
        
    }
}
