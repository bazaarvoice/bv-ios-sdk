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
    var pinReponse: Data?
    var currentConfig: DemoConfig!
    var prodConfig: DemoConfig?
    var stagingConfig: DemoConfig?
    var transactionHistory = [BVTransactionEvent]()
    var reviewHighlightsProductIds: [String] = []//Add your productIds here to enable or use the ReviewHighlights
    //Replace with valid UserToken string to test progressiveSubmission flow
    var userToken = "REPLACE_ME"
    
    init() {
        self.setupPreSelectedKeysIfPresent()
        self.setupMocking()
    }
  
  static let PRESELECTED_CONFIG_DISPLAY_NAME_KEY = "BV_PRE_SELECTED_CONFIG_DISPLAY_NAME"
  
  func configure(_ configType: BVConfigurationType) {
    
    var config: DemoConfig?
    if configType == .prod, prodConfig != nil{
      config = prodConfig!
    }else if configType == .staging, stagingConfig != nil {
      config = stagingConfig!
    }
    
    if let _ = config {
      switchToConfig(config: config!)
    }
  }
    
    func setupPreSelectedKeysIfPresent() {
        
        let defaults = UserDefaults(suiteName: "group.bazaarvoice.bvsdkdemo.app")
        let preselectedDisplayName = defaults!.string(forKey: MockDataManager.PRESELECTED_CONFIG_DISPLAY_NAME_KEY) ?? mockConfig.displayName
        
        let matchingConfig = configs.filter{ $0.displayName == preselectedDisplayName }.first
        if let config = matchingConfig {
            switchToConfig(config: config)
        }else {
            switchToConfig(config: mockConfig)
        }
    }
    
    func getReviewHighlightsProductIdForIndex(index: Int) -> String?  {
        
        if index > self.reviewHighlightsProductIds.count - 1 {
            return nil
        }
        
        return self.reviewHighlightsProductIds[index]
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
  let conversationsAuthorsMatch = "bazaarvoice.com/data/authors"
  let conversationsReviewSummary = "bazaarvoice.com/data/reviewsummary"
  let submitReviewMatch = "bazaarvoice.com/data/submitreview"
  let submitReviewPhotoMatch = "bazaarvoice.com/data/uploadphoto"
  let submitQuestionMatch = "bazaarvoice.com/data/submitquestion"
  let submitAnswerMatch = "bazaarvoice.com/data/submitanswer"
  let productSentimentsSummarisedFeatures = "bazaarvoice.com/sentiment/v1/summarised-features"
  let productSentimentsProductFeatures = "bazaarvoice.com/sentiment/v1/features"
  let productSentimentsProductQuotes = "bazaarvoice.com/sentiment/v1/quotes"

  var convoStoresConfigMatch = String(format:"s3.amazonaws.com/incubator-mobile-apps/sdk/%@/ios/%@/conversations-stores", S3_API_VERSION, "REPLACE_ME")
  var pinConfigMatch = String(format:"s3.amazonaws.com/incubator-mobile-apps/sdk/%@/ios/%@/pin", S3_API_VERSION, "REPLACE_ME")
  let pinRequestMatch = "bazaarvoice.com/pin/toreview"
  
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
    convoStoresConfigMatch = String(format:"s3.amazonaws.com/incubator-mobile-apps/sdk/%@/ios/%@/conversations-stores", S3_API_VERSION, currentConfig?.clientId ?? "REPLACE_ME")
    pinConfigMatch = String(format:"s3.amazonaws.com/incubator-mobile-apps/sdk/%@/ios/%@/pin", S3_API_VERSION,  currentConfig?.clientId ?? "REPLACE_ME")
    
    let containsCurations = url.contains(curationsUrlMatch)
    let containsCurationsPhotoPost = url.contains(curationsPhotoPostUrlMatch)
    let containsProfile = url.contains(profileUrlMatch)
    let containsRecommendations = url.contains(recommendationsUrlMatch)
    let containsConversations = url.contains(conversationsMatch)
    let containsConversationsQuestions = url.contains(conversationsQuestionsMatch)
    let containsConversationsProducts = url.contains(conversationsProductMatch)
    let containsConversationsAuthors = url.contains(conversationsAuthorsMatch)
    let containsConversationsReviewSummary = url.contains(conversationsReviewSummary)
    let containsSubmitReviews = url.contains(submitReviewMatch)
    let containsSubmitPhotoReviews = url.contains(submitReviewPhotoMatch)
    let containsSubmitQuestion = url.contains(submitQuestionMatch)
    let containsSubmitAnswers = url.contains(submitAnswerMatch)
    let containsConvoStoresConfig = url.contains(convoStoresConfigMatch)
    let containsPINConfig = url.contains(pinConfigMatch)
    let containsPINRequest = url.contains(pinRequestMatch)
    let containsPSSummarisedFeatures = url.contains(productSentimentsSummarisedFeatures)
    let containsPSProductFeatures = url.contains(productSentimentsProductFeatures)
    let containsPSProductQuotes = url.contains(productSentimentsProductQuotes)

    return containsCurations || containsCurationsPhotoPost || containsRecommendations || containsProfile || containsConversations || containsConversationsQuestions || containsConversationsProducts || containsConversationsAuthors || containsConversationsReviewSummary || containsSubmitReviews || containsSubmitPhotoReviews || containsSubmitQuestion || containsSubmitAnswers || containsConvoStoresConfig || containsPINConfig || containsPINRequest || containsPSSummarisedFeatures || containsPSProductFeatures || containsPSProductQuotes
    
  }
  
  func shouldMockData() -> Bool {
    return currentConfig?.isMock ?? true
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
      
      if url.contains(conversationsReviewSummary) {
          
          return OHHTTPStubsResponse(
            fileAtPath: OHPathForFile("conversationsReviewSummary.json", type(of: self))!,
            statusCode: 200,
            headers: ["Content-Type": "application/json;charset=utf-8"]
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
    
    if url.contains(conversationsAuthorsMatch) {
      
      return OHHTTPStubsResponse(
        fileAtPath: OHPathForFile("conversationsAuthorWithIncludes.json", type(of: self))!,
        statusCode: 200,
        headers: ["Content-Type": "application/json;charset=utf-8"]
      )
      
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

      if url.contains(productSentimentsSummarisedFeatures) {
        
        return OHHTTPStubsResponse(
          fileAtPath: OHPathForFile("summarisedFeatures.json", type(of: self))!,
          statusCode: 200,
          headers: ["Content-Type": "application/json;charset=utf-8"]
        )
        
      }

      if url.contains(productSentimentsProductFeatures) {
        
        return OHHTTPStubsResponse(
          fileAtPath: OHPathForFile("productFeatures.json", type(of: self))!,
          statusCode: 200,
          headers: ["Content-Type": "application/json;charset=utf-8"]
        )
        
      }

      if url.contains(productSentimentsProductQuotes) {
        
        return OHHTTPStubsResponse(
          fileAtPath: OHPathForFile("productQuotes.json", type(of: self))!,
          statusCode: 200,
          headers: ["Content-Type": "application/json;charset=utf-8"]
        )
        
      }

    if url.contains(convoStoresConfigMatch) {
      
      return OHHTTPStubsResponse(
        fileAtPath: OHPathForFile("testNotificationConfig.json", type(of: self))!,
        statusCode: 200,
        headers: ["Content-Type": "application/json;charset=utf-8"]
      )
      
    }
    
    if url.contains(pinConfigMatch) {
      
      return OHHTTPStubsResponse(
        fileAtPath: OHPathForFile("testNotificationProductConfig.json", type(of: self))!,
        statusCode: 200,
        headers: ["Content-Type": "application/json;charset=utf-8"]
      )
    }
    
    if url.contains(pinRequestMatch) {
      return OHHTTPStubsResponse(data: pinReponse ?? "[]".data(using: .utf8)!,
                                 statusCode: 200,
                                 headers: ["Content-Type": "application/json;charset=utf-8"])
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
      var json = try JSON(data: data)
      
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
  
  func generateMockPinReponse(fromProducts: [BVProduct]) {
    var pins = [Dictionary<String, Any>]()
    for product in fromProducts {
      var pinDict = [String: Any]()
      pinDict["avg_rating"] = product.reviewStatistics?.averageOverallRating
      pinDict["image_url"] = product.imageUrl
      pinDict["product_page_url"] = product.productPageUrl
      pinDict["name"] = product.name
      pinDict["id"] = product.identifier
      pins.append(pinDict)
    }
    
    do {
      pinReponse = try JSONSerialization.data(withJSONObject: pins, options: .prettyPrinted)
    }catch {
      
    }
    
  }
  
  private lazy var mockConfig: DemoConfig =  {
    let configDict = MockDataManager.getDefaultConfigDict()
    let config = DemoConfig(dictionary: configDict as NSDictionary)
    config.isMock = true
    
    return config
  }()
  
  private class func getDefaultConfigDict() -> Dictionary<String, AnyObject> {
    return ["clientId": "REPLACE_ME" as AnyObject,
            "displayName": "(Mock) Endurance Cycles" as AnyObject,
            "apiKeyShopperAdvertising": "REPLACE_ME" as AnyObject,
            "apiKeyConversations": "REPLACE_ME" as AnyObject,
            "apiKeyConversationsStores": "REPLACE_ME" as AnyObject,
            "apiKeyCurations": "REPLACE_ME" as AnyObject,
            "apiKeyProductSentiments": "REPLACE_ME" as AnyObject,
            "apiKeyPIN": "REPLACE_ME" as AnyObject,
            "apiKeyLocation": "00000000-0000-0000-0000-000000000000" as AnyObject]
  }
  
  private lazy var fromFileConfigs: [DemoConfig] =  {
    
    var stagingFilePath = Bundle.main.path(forResource: "bvsdk_config_staging", ofType: "json")
    var prodFilePath = Bundle.main.path(forResource: "bvsdk_config_prod", ofType: "json")
    
    var configs = [DemoConfig]()
    
    var stagingConfigDict = MockDataManager.getDefaultConfigDict()
    if let staging = stagingFilePath, var configDict = MockDataManager.getJSON(from: staging) {
      configDict["displayName"] = "Staging Config" as AnyObject?
      
      for key in configDict.keys {
        stagingConfigDict[key] = configDict[key]
      }
      
      self.stagingConfig = DemoConfig(dictionary: stagingConfigDict as NSDictionary)
      self.stagingConfig?.configType = .staging
      configs.append(self.stagingConfig!)
    }
    
    var prodConfigDict = MockDataManager.getDefaultConfigDict()
    if let prod = prodFilePath, var configDict = MockDataManager.getJSON(from: prod) {
      configDict["displayName"] = "Prod Config" as AnyObject?
      
      for key in configDict.keys {
        prodConfigDict[key] = configDict[key]
      }
      
      self.prodConfig = DemoConfig(dictionary: prodConfigDict as NSDictionary)
      configs.append(self.prodConfig!)
    }
    
    return configs
  }()
  
  private class func getJSON(from filepath: String) -> Dictionary<String, AnyObject>? {
    if let data = try? Data(contentsOf: URL(fileURLWithPath: filepath)) {
      if let json = try? JSONSerialization.jsonObject(with: data, options:.init(rawValue: 0)) {
        return json as? Dictionary<String, AnyObject>;
      }
    }
    return nil
  }
  
  func switchToConfig(config: DemoConfig) {
    if currentConfig != nil {
      currentConfig.isSelected = false
    }
    
    currentConfig = config
    currentConfig.isSelected = true
    let defaults = UserDefaults(suiteName: "group.bazaarvoice.bvsdkdemo.app")
    defaults!.set(currentConfig.displayName, forKey: MockDataManager.PRESELECTED_CONFIG_DISPLAY_NAME_KEY)
    BVSDKManager.configure(withConfiguration: currentConfig?.raw as! [AnyHashable : Any], configType: currentConfig.configType)
  }
  
  lazy var configs : [DemoConfig] = {
    var configs = [DemoConfig]()
    configs.append(contentsOf: self.fromFileConfigs)
    configs.append(self.mockConfig)
    
    guard let path = Bundle.main.path(forResource: "config/DemoAppConfigs", ofType: "plist") else { return configs }
    guard let contents = NSArray(contentsOfFile: path) else { return configs }
    print(contents)
    configs += contents.map{ DemoConfig(dictionary: $0 as! NSDictionary) }
    return configs
  }()
  
}

class DemoConfig {
  
  let clientId, displayName, curationsKey, conversationsKey, conversationsStoresKey, shopperAdvertisingKey, locationKey, pinKey : String
  let raw: NSDictionary
  var isMock: Bool
  var isSelected: Bool!
  var configType = BVConfigurationType.prod
  
  init(dictionary:NSDictionary) {
    raw = dictionary;
    clientId = dictionary["clientId"] as? String ?? "REPLACE_ME"
    displayName = dictionary["displayName"] as? String ?? "REPLACE_ME"
    curationsKey = dictionary["apiKeyCurations"] as? String ?? "REPLACE_ME"
    conversationsKey = dictionary["apiKeyConversations"] as? String ?? "REPLACE_ME"
    conversationsStoresKey = dictionary["apiKeyConversationsStores"] as? String ?? "REPLACE_ME"
    shopperAdvertisingKey = dictionary["apiKeyShopperAdvertising"] as? String ?? "REPLACE_ME"
    locationKey = dictionary["apiKeyLocation"] as? String ?? "00000000-0000-0000-0000-000000000000"
    pinKey = dictionary["apiKeyPIN"] as? String ?? "REPLACE_ME"
    isMock = false
    isSelected = false
  }
}
