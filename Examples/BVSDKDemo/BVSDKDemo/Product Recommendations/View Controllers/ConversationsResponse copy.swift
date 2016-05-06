//
//  ConversationsResponse.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import Foundation

enum IncludeParameter: String {
    case Products, Categories, Authors, Comments, Answers, Reviews, Questions
}

class Product: GenericConversationsResult {
    
    static var allowedIncludeParams: [IncludeParameter] {
        get {
            return [.Reviews, .Products, .Categories, .Authors, .Questions]
        }
    }
    
    let description, productPageUrl, imageUrl, name, categoryId : String
    let reviews : [BaseReview]
    
    required init(apiResponse: NSDictionary, includes : ConversationsInclude?) {
        
        description = apiResponse["Description"] as! String
        productPageUrl = apiResponse["ProductPageUrl"] as! String
        imageUrl = apiResponse["ImageUrl"] as! String
        name = apiResponse["Name"] as! String
        categoryId = apiResponse["CategoryId"] as! String
        
        
        var mutableReviews : [BaseReview] = []
        for reviewId in apiResponse["ReviewIds"] as! [String] {
            if let review = includes?.getReviewById(reviewId) {
                mutableReviews.append(review)
            }
        }
        reviews = mutableReviews
        
    }
    
}

class ConversationsInclude {
    
    let products : [String : Product]
    let authors : [String : Author]
    let answers : [String : Answer]
    let reviews : [String : BaseReview]
    
    init(apiResponse : NSDictionary) {
        
        
        var productsMutable : [String:Product] = [:]
        
        if let productsDictionary = apiResponse["Products"] as? NSDictionary {
        
            for (productId, productDetails) in productsDictionary {
                
                productsMutable[productId as! String] = Product(apiResponse: productDetails as! NSDictionary, includes: nil)
                
            }
            
        }
        
        products = productsMutable
        
        
        
        var authorsMutable : [String:Author] = [:]
        
        if let authorsDictionary = apiResponse["Authors"] as? NSDictionary {
        
            for (authorId, authorDetails) in authorsDictionary {
                
                authorsMutable[authorId as! String] = Author(apiResponse: authorDetails as! NSDictionary)
                
            }
            
        }
        
        authors = authorsMutable
        
        
        
        var answersMutable : [String:Answer] = [:]
        
        if let answersDictionary = apiResponse["Answers"] as? NSDictionary {
            
            for (answerId, answerDetails) in answersDictionary {
                
                answersMutable[answerId as! String] = Answer(apiResponse: answerDetails as! NSDictionary)
                
            }
            
        }
        
        answers = answersMutable
        
        
        
        
        var reviewsMutable : [String:BaseReview] = [:]
        
        if let reviewsDictionary = apiResponse["Reviews"] as? NSDictionary {
            
            for (reviewId, reviewDetails) in reviewsDictionary {
                
                reviewsMutable[reviewId as! String] = BaseReview(apiResponse: reviewDetails as! NSDictionary, includes: nil)
                
            }
            
        }
        
        reviews = reviewsMutable
        
    }
    
    func getAuthorById(authorId: String) -> Author? {
        
        return authors[authorId]
        
    }
    
    func getAnswerById(answerId: String) -> Answer? {
        
        return answers[answerId]
        
    }
    
    func getReviewById(reviewId: String) -> BaseReview? {
        
        return reviews[reviewId]
        
    }
    
}

protocol GenericConversationsResult {
    
    static var allowedIncludeParams : [IncludeParameter] { get }
    
    init(apiResponse: NSDictionary, includes: ConversationsInclude?)
    
}

class BaseReview: GenericConversationsResult {
    
    static var allowedIncludeParams: [IncludeParameter] {
        get{
            return [.Products, .Categories, .Authors, .Comments]
        }
    }
    
    let reviewText, productId, title : String
    let rating : Float

    
    required init(apiResponse: NSDictionary, includes: ConversationsInclude?) {
        
        reviewText = apiResponse["ReviewText"] as! String
        productId = apiResponse["ProductId"] as! String
        title = apiResponse["Title"] as! String
        rating = apiResponse["Rating"] as! Float
        
    }
    
}

class Review : BaseReview {
    
    let author : Author?
    
    required init(apiResponse : NSDictionary, includes: ConversationsInclude?) {
        
        let authorId = apiResponse["AuthorId"] as! String
        author = includes?.getAuthorById(authorId)
        
        super.init(apiResponse: apiResponse, includes: includes)
        
    }
    
}

class Answer {
    
//    var allowedIncludeParams: [IncludeParameter] {
//        get {
//            return [.Products, .Categories, .Authors, .Questions]
//        }
//    }
    
    let userNickname, answerText : String
    
    required init(apiResponse : NSDictionary) {
        
        userNickname = apiResponse["UserNickname"] as! String
        answerText = apiResponse["AnswerText"] as! String
        
    }
}

class Author {
    
    let userNickname : String
    
    init(apiResponse : NSDictionary) {
        
        userNickname = apiResponse["UserNickname"] as! String
        
    }
    
}

class Question: GenericConversationsResult {
    
    static var allowedIncludeParams: [IncludeParameter] {
        get{
            return [.Products, .Categories, .Authors, .Answers]
        }
    }
    
    let userNickname : String?
    let questionSummary, productId : String
    let totalAnswerCount : Int
    let author : Author?
    let answers : [Answer]
    
    required init(apiResponse: NSDictionary, includes : ConversationsInclude?) {
        
        questionSummary = apiResponse["QuestionSummary"] as! String
        userNickname = apiResponse["UserNickname"] as? String
        productId = apiResponse["Id"] as! String
        totalAnswerCount = apiResponse["TotalAnswerCount"] as! Int
        
        let authorId = apiResponse["AuthorId"] as! String
        author = includes?.getAuthorById(authorId)
        
        var mutableAnswers : [Answer] = []
        for answerId in apiResponse["AnswerIds"] as! [String] {
            
            if let answer = includes?.getAnswerById(answerId) {
                mutableAnswers.append(answer)
            }
            
        }
        answers = mutableAnswers
        
    }
    
}

class Comment: GenericConversationsResult {
    
    static var allowedIncludeParams: [IncludeParameter] {
        get {
            return [.Reviews, .Products, .Categories, .Authors]
        }
    }
    
    required init(apiResponse: NSDictionary, includes : ConversationsInclude?) {
        
    }
    
}



class ConversationsError {
    
    let message, code : String
    
    init(apiResponse: NSDictionary) {
        
        message = apiResponse["Message"] as! String
        code = apiResponse["Code"] as! String
        
    }
    
}

class ConversationsErrorResponse {
    
    let errors : [ConversationsError]
    
    init?(apiResponse : NSDictionary) {
        
        let rawErrors = apiResponse["Errors"] as! Array<NSDictionary>
        errors = (rawErrors).map{ ConversationsError(apiResponse: $0) }
        
        if errors.count == 0 {
            return nil
        }
        
    }
    
}

class ConversationsResponse<DataType: GenericConversationsResult>{
    
    let includes : ConversationsInclude
    let offset : Int
    let locale : String
    let results : [DataType]
    let totalResults : Int
    let limit : Int
    
    init(apiResponse: NSDictionary) {
        limit = apiResponse["Limit"] as! Int
        totalResults = apiResponse["TotalResults"] as! Int
        locale = apiResponse["Locale"] as! String
        offset = apiResponse["Offset"] as! Int
        
        self.includes = ConversationsInclude(apiResponse: apiResponse["Includes"] as! NSDictionary)
        
        var resultsHolder : [DataType] = []
        for result in apiResponse["Results"] as! Array<NSDictionary> {
            resultsHolder.append(DataType(apiResponse: result, includes: self.includes))
        }
        results = resultsHolder
        
    }
    
}

class ConversationsRequest<DataType: GenericConversationsResult> {
    
    var limit : Int?
    let allowedIncludes = DataType.allowedIncludeParams
    private let includes : [IncludeParameter]?
    
    init(limit: Int?, includes: [IncludeParameter]?) {
        self.limit = limit
        self.includes = includes
    }
    
}

typealias conversationsCompletionHandler = ([Review]) -> Void
typealias conversationsFailureHandler = (NSError) -> Void

class ReviewRequest<T: GenericConversationsResult>: ConversationsRequest<T> {
    
    func sendRequest(completion: conversationsCompletionHandler, failure: conversationsFailureHandler) {
        
        
        
    }
    
}