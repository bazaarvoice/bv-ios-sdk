//
//  ConversationsInclude.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationsInclude.h"

@interface BVConversationsInclude()

@property NSDictionary<NSString*, BVProduct*>* _Nonnull products;
@property NSDictionary<NSString*, BVReview*>* _Nonnull reviews;
@property NSDictionary<NSString*, BVQuestion*>* _Nonnull questions;
@property NSDictionary<NSString*, BVAnswer*>* _Nonnull answers;
@property NSDictionary<NSString*, BVComment*>* _Nonnull comments;
@property NSDictionary<NSString*, BVAuthor*>* _Nonnull authors;

@end

@implementation BVConversationsInclude

-(BVAnswer* _Nullable)getAnswerById:(NSString* _Nonnull)answerId {
    return self.answers[answerId];
}

-(BVProduct* _Nullable)getProductById:(NSString* _Nonnull)productId {
    return self.products[productId];
}

-(BVReview* _Nullable)getReviewById:(NSString* _Nonnull)reviewId {
    return self.reviews[reviewId];
}

-(BVQuestion* _Nullable)getQuestionById:(NSString* _Nonnull)questionId {
    return self.questions[questionId];
}

-(BVComment* _Nullable)getCommentById:(NSString *)commentId {
    return self.comments[commentId];
}

-(BVAuthor* _Nullable)getAuthorById:(NSString *)authorId {
    return self.authors[authorId];
}

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse {
    self = [super init];
    if(self){
        _apiResponse = apiResponse;
        
        NSDictionary* reviewsDict = apiResponse[@"Reviews"];
        NSMutableDictionary<NSString*, BVReview*>* tempReviews = [NSMutableDictionary dictionary];
        for(NSString* key in reviewsDict){
            tempReviews[key] = [[BVReview alloc] initWithApiResponse:reviewsDict[key] includes:nil];
        }
        self.reviews = [NSDictionary dictionaryWithDictionary:tempReviews];
        
        NSDictionary* questionsDict = apiResponse[@"Questions"];
        NSMutableDictionary<NSString*, BVQuestion*>* tempQuestions = [NSMutableDictionary dictionary];
        for(NSString* key in questionsDict){
            tempQuestions[key] = [[BVQuestion alloc] initWithApiResponse:questionsDict[key] includes:nil];
        }
        self.questions = [NSDictionary dictionaryWithDictionary:tempQuestions];
        
        NSDictionary* productsDict = apiResponse[@"Products"];
        NSMutableDictionary<NSString*, BVProduct*>* tempProducts = [NSMutableDictionary dictionary];
        for(NSString* key in productsDict){
            tempProducts[key] = [[BVProduct alloc] initWithApiResponse:productsDict[key] includes:nil];
        }
        self.products = [NSDictionary dictionaryWithDictionary:tempProducts];
        
        NSDictionary* answersDict = apiResponse[@"Answers"];
        NSMutableDictionary<NSString*, BVAnswer*>* tempAnswers = [NSMutableDictionary dictionary];
        for(NSString* key in answersDict){
            tempAnswers[key] = [[BVAnswer alloc] initWithApiResponse:answersDict[key] includes:nil];
        }
        self.answers = [NSDictionary dictionaryWithDictionary:tempAnswers];
        
        NSDictionary* commentsDict = apiResponse[@"Comments"];
        NSMutableDictionary<NSString*, BVComment*> *tempComments = [NSMutableDictionary dictionary];
        for (NSString *key in commentsDict){
            tempComments[key] = [[BVComment alloc] initWithApiResponse:commentsDict[key] includes:nil];
        }
        self.comments =  [NSDictionary dictionaryWithDictionary:tempComments];
        
        NSDictionary* authorsDict = apiResponse[@"Authors"];
        NSMutableDictionary<NSString*, BVAuthor*> *tempAuthors = [NSMutableDictionary dictionary];
        for (NSString *key in authorsDict){
            tempAuthors[key] = [[BVAuthor alloc] initWithApiResponse:authorsDict[key] includes:nil];
        }
        self.authors =  [NSDictionary dictionaryWithDictionary:tempAuthors];
    }
    return self;
}

@end
