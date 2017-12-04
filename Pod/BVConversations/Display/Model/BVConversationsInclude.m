//
//  ConversationsInclude.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationsInclude.h"

@interface BVConversationsInclude ()

@property(nonnull) NSDictionary<NSString *, BVProduct *> *products;
@property(nonnull) NSDictionary<NSString *, BVReview *> *reviews;
@property(nonnull) NSDictionary<NSString *, BVQuestion *> *questions;
@property(nonnull) NSDictionary<NSString *, BVAnswer *> *answers;
@property(nonnull) NSDictionary<NSString *, BVComment *> *comments;
@property(nonnull) NSDictionary<NSString *, BVAuthor *> *authors;

@end

@implementation BVConversationsInclude

- (nullable BVAnswer *)getAnswerById:(nonnull NSString *)answerId {
  return self.answers[answerId];
}

- (nullable BVProduct *)getProductById:(nonnull NSString *)productId {
  return self.products[productId];
}

- (nullable BVReview *)getReviewById:(nonnull NSString *)reviewId {
  return self.reviews[reviewId];
}

- (nullable BVQuestion *)getQuestionById:(nonnull NSString *)questionId {
  return self.questions[questionId];
}

- (nullable BVComment *)getCommentById:(NSString *)commentId {
  return self.comments[commentId];
}

- (nullable BVAuthor *)getAuthorById:(NSString *)authorId {
  return self.authors[authorId];
}

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  self = [super init];
  if (self) {
    _apiResponse = apiResponse;

    NSDictionary *reviewsDict = apiResponse[@"Reviews"];
    NSMutableDictionary<NSString *, BVReview *> *tempReviews =
        [NSMutableDictionary dictionary];
    for (NSString *key in reviewsDict) {
      tempReviews[key] =
          [[BVReview alloc] initWithApiResponse:reviewsDict[key] includes:nil];
    }
    self.reviews = [NSDictionary dictionaryWithDictionary:tempReviews];

    NSDictionary *questionsDict = apiResponse[@"Questions"];
    NSMutableDictionary<NSString *, BVQuestion *> *tempQuestions =
        [NSMutableDictionary dictionary];
    for (NSString *key in questionsDict) {
      tempQuestions[key] =
          [[BVQuestion alloc] initWithApiResponse:questionsDict[key]
                                         includes:nil];
    }
    self.questions = [NSDictionary dictionaryWithDictionary:tempQuestions];

    NSDictionary *productsDict = apiResponse[@"Products"];
    NSMutableDictionary<NSString *, BVProduct *> *tempProducts =
        [NSMutableDictionary dictionary];
    for (NSString *key in productsDict) {
      tempProducts[key] =
          [[BVProduct alloc] initWithApiResponse:productsDict[key]
                                        includes:nil];
    }
    self.products = [NSDictionary dictionaryWithDictionary:tempProducts];

    NSDictionary *answersDict = apiResponse[@"Answers"];
    NSMutableDictionary<NSString *, BVAnswer *> *tempAnswers =
        [NSMutableDictionary dictionary];
    for (NSString *key in answersDict) {
      tempAnswers[key] =
          [[BVAnswer alloc] initWithApiResponse:answersDict[key] includes:nil];
    }
    self.answers = [NSDictionary dictionaryWithDictionary:tempAnswers];

    NSDictionary *commentsDict = apiResponse[@"Comments"];
    NSMutableDictionary<NSString *, BVComment *> *tempComments =
        [NSMutableDictionary dictionary];
    for (NSString *key in commentsDict) {
      tempComments[key] =
          [[BVComment alloc] initWithApiResponse:commentsDict[key]
                                        includes:nil];
    }
    self.comments = [NSDictionary dictionaryWithDictionary:tempComments];

    NSDictionary *authorsDict = apiResponse[@"Authors"];
    NSMutableDictionary<NSString *, BVAuthor *> *tempAuthors =
        [NSMutableDictionary dictionary];
    for (NSString *key in authorsDict) {
      tempAuthors[key] =
          [[BVAuthor alloc] initWithApiResponse:authorsDict[key] includes:nil];
    }
    self.authors = [NSDictionary dictionaryWithDictionary:tempAuthors];
  }
  return self;
}

@end
