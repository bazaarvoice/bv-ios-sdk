////
////  ConversationsResponse.swift
////  BVSDKDemo
////
////  Copyright © 2016 Bazaarvoice. All rights reserved.
////
//
//
//import Foundation
//
//enum IncludeParameter: String {
//    case Products, Categories, Authors, Comments, Answers, Reviews, Questions
//}
//
//class Product: GenericConversationsResult {
//    
//    static var allowedIncludeParams: [IncludeParameter] {
//        get {
//            return [.Reviews, .Products, .Categories, .Authors, .Questions]
//        }
//    }
//    
//    let description, productPageUrl, imageUrl, name, categoryId : String?
//    var helpfulReviewVoteCount = 0, notHelpfulReviewVoteCount = 0 // review statistics, overall for the product
//    let reviews : [BaseReview]
//    let qaStatistics : NSDictionary?
//    let reviewStatistics : NSDictionary?
//    
//    required init(apiResponse: NSDictionary, includes : ConversationsInclude?) {
//        
//        description = apiResponse["Description"] as? String
//        productPageUrl = apiResponse["ProductPageUrl"] as? String
//        imageUrl = apiResponse["ImageUrl"] as? String
//        name = apiResponse["Name"] as? String
//        categoryId = apiResponse["CategoryId"] as?  String
//        qaStatistics = apiResponse["QAStatistics"] as? NSDictionary
//        reviewStatistics = apiResponse["ReviewStatistics"] as? NSDictionary
//        if reviewStatistics != nil {
//            helpfulReviewVoteCount = reviewStatistics!["HelpfulVoteCount"] as! Int
//            notHelpfulReviewVoteCount = reviewStatistics!["NotHelpfulVoteCount"] as! Int
//        }
//        
//        var mutableReviews : [BaseReview] = []
//        for reviewId in apiResponse["ReviewIds"] as! [String] {
//            if let review = includes?.getReviewById(reviewId) {
//                mutableReviews.append(review)
//            }
//        }
//        reviews = mutableReviews
//        
//    }
//    
//}
//
//class ConversationsInclude {
//    
//    let products : [String : Product]
//    let authors : [String : Author]
//    let answers : [String : Answer]
//    let reviews : [String : BaseReview]
//    
//    init(apiResponse : NSDictionary) {
//        
//        
//        var productsMutable : [String:Product] = [:]
//        
//        if let productsDictionary = apiResponse["Products"] as? NSDictionary {
//            
//            for (productId, productDetails) in productsDictionary {
//                
//                productsMutable[productId as! String] = Product(apiResponse: productDetails as! NSDictionary, includes: nil)
//                
//            }
//            
//        }
//        
//        products = productsMutable
//        
//        
//        
//        var authorsMutable : [String:Author] = [:]
//        
//        if let authorsDictionary = apiResponse["Authors"] as? NSDictionary {
//            
//            for (authorId, authorDetails) in authorsDictionary {
//                
//                authorsMutable[authorId as! String] = Author(apiResponse: authorDetails as! NSDictionary)
//                
//            }
//            
//        }
//        
//        authors = authorsMutable
//        
//        
//        
//        var answersMutable : [String:Answer] = [:]
//        
//        if let answersDictionary = apiResponse["Answers"] as? NSDictionary {
//            
//            for (answerId, answerDetails) in answersDictionary {
//                
//                answersMutable[answerId as! String] = Answer(apiResponse: answerDetails as! NSDictionary, includes: nil)
//                
//            }
//            
//        }
//        
//        answers = answersMutable
//        
//        
//        
//        
//        var reviewsMutable : [String:BaseReview] = [:]
//        
//        if let reviewsDictionary = apiResponse["Reviews"] as? NSDictionary {
//            
//            for (reviewId, reviewDetails) in reviewsDictionary {
//                
//                reviewsMutable[reviewId as! String] = BaseReview(apiResponse: reviewDetails as! NSDictionary, includes: nil)
//                
//            }
//            
//        }
//        
//        reviews = reviewsMutable
//        
//    }
//    
//    func getAuthorById(authorId: String) -> Author? {
//        
//        return authors[authorId]
//        
//    }
//    
//    func getAnswerById(answerId: String) -> Answer? {
//        
//        return answers[answerId]
//        
//    }
//    
//    func getReviewById(reviewId: String) -> BaseReview? {
//        
//        return reviews[reviewId]
//        
//    }
//    
//}
//
//protocol GenericConversationsResult {
//    
//    static var allowedIncludeParams : [IncludeParameter] { get }
//    
//    init(apiResponse: NSDictionary, includes: ConversationsInclude?)
//    
//}
//
//class BaseReview: GenericConversationsResult {
//    
//    static var allowedIncludeParams: [IncludeParameter] {
//        get{
//            return [.Products, .Categories, .Authors, .Comments]
//        }
//    }
//    
//    let reviewText, productId, title, userLocation : String?
//    var thumbNailImageUrl, normalImageUrl : String?
//    var totalFeedbackCount = 0, totalNegativeFeedbackCount = 0, totalPositiveFeedbackCount = 0
//    let submissionTime : NSDate?
//    let rating : Float?
//    
//    
//    required init(apiResponse: NSDictionary, includes: ConversationsInclude?) {
//        
//        reviewText = apiResponse["ReviewText"] as? String
//        productId = apiResponse["ProductId"] as? String
//        title = apiResponse["Title"] as? String
//        userLocation = apiResponse["UserLocation"] as? String
//        totalFeedbackCount = apiResponse["TotalFeedbackCount"] as! Int
//        totalNegativeFeedbackCount = apiResponse["TotalNegativeFeedbackCount"] as! Int
//        totalPositiveFeedbackCount = apiResponse["TotalPositiveFeedbackCount"] as! Int
//        rating = apiResponse["Rating"] as? Float
//        let photos = (apiResponse["Photos"] as? [Dictionary<String, AnyObject>])!
//        
//        if photos.count > 0  {
//            normalImageUrl = photos[0]["Sizes"]?["normal"]!?["Url"] as? String
//            
//            thumbNailImageUrl = photos[0]["Sizes"]?["thumbnail"]!?["Url"] as? String
//            
//        }
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX" // UTC format
//        let dateString = apiResponse["SubmissionTime"] as? String ?? ""
//        submissionTime = dateFormatter.dateFromString(dateString)
//        
//        
//    }
//    
//}
//
//class Review : BaseReview {
//    
//    let author : Author?
//    
//    required init(apiResponse : NSDictionary, includes: ConversationsInclude?) {
//        
//        let authorId = apiResponse["AuthorId"] as! String
//        author = includes?.getAuthorById(authorId)
//        
//        super.init(apiResponse: apiResponse, includes: includes)
//        
//    }
//    
//}
//
//class BaseAnswer: GenericConversationsResult {
//    
//    static var allowedIncludeParams: [IncludeParameter] {
//        get {
//            return [.Products, .Categories, .Authors, .Questions]
//        }
//    }
//    
//    let userNickname, answerText : String?
//    let submissionTime : NSDate?
//    var totalFeedbackCount = 0, totalNegativeFeedbackCount = 0, totalPositiveFeedbackCount = 0
//    
//    required init(apiResponse: NSDictionary, includes: ConversationsInclude?) {
//        
//        userNickname = apiResponse["UserNickname"] as? String
//        answerText = apiResponse["AnswerText"] as? String
//        
//        totalFeedbackCount = apiResponse["TotalFeedbackCount"] as! Int
//        totalNegativeFeedbackCount = apiResponse["TotalNegativeFeedbackCount"] as! Int
//        totalPositiveFeedbackCount = apiResponse["TotalPositiveFeedbackCount"] as! Int
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX" // UTC format
//        let dateString = apiResponse["SubmissionTime"] as? String ?? ""
//        submissionTime = dateFormatter.dateFromString(dateString)
//        
//    }
//}
//
//class Answer : BaseAnswer {
//    
//}
//
//class Author {
//    
//    let userNickname : String
//    
//    init(apiResponse : NSDictionary) {
//        
//        userNickname = apiResponse["UserNickname"] as! String
//        
//    }
//    
//}
//
//class Question: GenericConversationsResult {
//    
//    static var allowedIncludeParams: [IncludeParameter] {
//        get{
//            return [.Products, .Categories, .Authors, .Answers]
//        }
//    }
//    
//    let questionId : String!
//    let userNickname, questionDetails : String?
//    let questionSummary, productId : String
//    let totalAnswerCount : Int
//    let author : Author?
//    let answers : [Answer]
//    let submissionTime : NSDate?
//    var totalFeedbackCount = 0, totalNegativeFeedbackCount = 0, totalPositiveFeedbackCount = 0
//    
//    required init(apiResponse: NSDictionary, includes : ConversationsInclude?) {
//        
//        questionId = apiResponse["Id"] as! String
//        questionSummary = apiResponse["QuestionSummary"] as! String
//        questionDetails = apiResponse["QuestionDetails"] as? String
//        totalFeedbackCount = apiResponse["TotalFeedbackCount"] as! Int
//        totalNegativeFeedbackCount = apiResponse["TotalNegativeFeedbackCount"] as! Int
//        totalPositiveFeedbackCount = apiResponse["TotalPositiveFeedbackCount"] as! Int
//        userNickname = apiResponse["UserNickname"] as? String
//        productId = apiResponse["Id"] as! String
//        totalAnswerCount = apiResponse["TotalAnswerCount"] as! Int
//        
//        let authorId = apiResponse["AuthorId"] as! String
//        author = includes?.getAuthorById(authorId)
//        
//        var mutableAnswers : [Answer] = []
//        for answerId in apiResponse["AnswerIds"] as! [String] {
//            
//            if let answer = includes?.getAnswerById(answerId) {
//                mutableAnswers.append(answer)
//            }
//            
//        }
//        answers = mutableAnswers
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX" // UTC format
//        let dateString = apiResponse["SubmissionTime"] as? String ?? ""
//        submissionTime = dateFormatter.dateFromString(dateString)
//        
//    }
//    
//}
//
//class Comment: GenericConversationsResult {
//    
//    static var allowedIncludeParams: [IncludeParameter] {
//        get {
//            return [.Reviews, .Products, .Categories, .Authors]
//        }
//    }
//    
//    required init(apiResponse: NSDictionary, includes : ConversationsInclude?) {
//        
//    }
//    
//}
//
//
//
//class ConversationsError {
//    
//    let message, code : String
//    
//    init(apiResponse: NSDictionary) {
//        
//        message = apiResponse["Message"] as! String
//        code = apiResponse["Code"] as! String
//        
//    }
//    
//}
//
//class ConversationsErrorResponse {
//    
//    let errors : [ConversationsError]
//    
//    init?(apiResponse : NSDictionary) {
//        
//        let rawErrors = apiResponse["Errors"] as! Array<NSDictionary>
//        errors = (rawErrors).map{ ConversationsError(apiResponse: $0) }
//        
//        if errors.count == 0 {
//            return nil
//        }
//        
//    }
//    
//}
//
//class ConversationsResponse<DataType: GenericConversationsResult>{
//    
//    let includes : ConversationsInclude
//    let offset : Int?
//    let locale : String?
//    let results : [DataType]
//    let totalResults : Int?
//    let limit : Int?
//    
//    init(apiResponse: NSDictionary) {
//        
//        limit = apiResponse["Limit"] as? Int
//        totalResults = apiResponse["TotalResults"] as? Int
//        locale = apiResponse["Locale"] as? String
//        offset = apiResponse["Offset"] as? Int
//        
//        self.includes = ConversationsInclude(apiResponse: apiResponse["Includes"] as! NSDictionary)
//        
//        var resultsHolder : [DataType] = []
//        for result in apiResponse["Results"] as! Array<NSDictionary> {
//            resultsHolder.append(DataType(apiResponse: result, includes: self.includes))
//        }
//        results = resultsHolder
//        
//    }
//    
//}
//
//class ConversationsRequest<DataType: GenericConversationsResult> {
//    
//    var limit : Int?
//    let allowedIncludes = DataType.allowedIncludeParams
//    private let includes : [IncludeParameter]?
//    
//    init(limit: Int?, includes: [IncludeParameter]?) {
//        self.limit = limit
//        self.includes = includes
//    }
//    
//}
//
//typealias conversationsCompletionHandler = ([Review]) -> Void
//typealias conversationsFailureHandler = (NSError) -> Void
//
//class ReviewRequest<T: GenericConversationsResult>: ConversationsRequest<T> {
//    
//    func sendRequest(completion: conversationsCompletionHandler, failure: conversationsFailureHandler) {
//        
//        
//        
//    }
//    
//}