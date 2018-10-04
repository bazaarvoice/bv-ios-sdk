//
//  ConversationsInclude.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationsInclude.h"
#import "BVGenericConversationsResult+Private.h"

@interface BVConversationsInclude ()

@property(nonatomic, readwrite)
    NSDictionary<NSString *, BVAnswer *> *answersDict;
@property(nonatomic, readwrite)
    NSDictionary<NSString *, BVAuthor *> *authorsDict;
@property(nonatomic, readwrite)
    NSDictionary<NSString *, BVComment *> *commentsDict;
@property(nonatomic, readwrite)
    NSDictionary<NSString *, BVProduct *> *productsDict;
@property(nonatomic, readwrite)
    NSDictionary<NSString *, BVQuestion *> *questionsDict;
@property(nonatomic, readwrite)
    NSDictionary<NSString *, BVReview *> *reviewsDict;

@end

@implementation BVConversationsInclude

- (nonnull NSArray<BVAnswer *> *)getAnswers {
  return self.answersDict.allValues;
}

- (nonnull NSArray<BVAuthor *> *)getAuthors {
  return self.authorsDict.allValues;
}

- (nonnull NSArray<BVComment *> *)getComments {
  return self.commentsDict.allValues;
}

- (nonnull NSArray<BVProduct *> *)getProducts {
  return self.productsDict.allValues;
}

- (nonnull NSArray<BVQuestion *> *)getQuestions {
  return self.questionsDict.allValues;
}

- (nonnull NSArray<BVReview *> *)getReviews {
  return self.reviewsDict.allValues;
}

- (nullable BVAnswer *)getAnswerById:(nonnull NSString *)answerId {
  return self.answersDict[answerId];
}

- (nullable BVAuthor *)getAuthorById:(NSString *)authorId {
  return self.authorsDict[authorId];
}

- (nullable BVComment *)getCommentById:(NSString *)commentId {
  return self.commentsDict[commentId];
}

- (nullable BVProduct *)getProductById:(nonnull NSString *)productId {
  return self.productsDict[productId];
}

- (nullable BVQuestion *)getQuestionById:(nonnull NSString *)questionId {
  return self.questionsDict[questionId];
}

- (nullable BVReview *)getReviewById:(nonnull NSString *)reviewId {
  return self.reviewsDict[reviewId];
}

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  if ((self = [super init])) {
    _apiResponse = apiResponse;

    NSDictionary *answersDict = apiResponse[@"Answers"];
    NSMutableDictionary<NSString *, BVAnswer *> *tempAnswers =
        [NSMutableDictionary dictionary];
    for (NSString *key in answersDict) {
      tempAnswers[key] =
          [[BVAnswer alloc] initWithApiResponse:answersDict[key] includes:nil];
    }
    self.answersDict = [NSDictionary dictionaryWithDictionary:tempAnswers];

    NSDictionary *authorsDict = apiResponse[@"Authors"];
    NSMutableDictionary<NSString *, BVAuthor *> *tempAuthors =
        [NSMutableDictionary dictionary];
    for (NSString *key in authorsDict) {
      tempAuthors[key] =
          [[BVAuthor alloc] initWithApiResponse:authorsDict[key] includes:nil];
    }
    self.authorsDict = [NSDictionary dictionaryWithDictionary:tempAuthors];

    NSDictionary *commentsDict = apiResponse[@"Comments"];
    NSMutableDictionary<NSString *, BVComment *> *tempComments =
        [NSMutableDictionary dictionary];
    for (NSString *key in commentsDict) {
      tempComments[key] =
          [[BVComment alloc] initWithApiResponse:commentsDict[key]
                                        includes:nil];
    }
    self.commentsDict = [NSDictionary dictionaryWithDictionary:tempComments];

    NSDictionary *productsDict = apiResponse[@"Products"];
    NSMutableDictionary<NSString *, BVProduct *> *tempProducts =
        [NSMutableDictionary dictionary];
    for (NSString *key in productsDict) {
      tempProducts[key] =
          [[BVProduct alloc] initWithApiResponse:productsDict[key]
                                        includes:nil];
    }
    self.productsDict = [NSDictionary dictionaryWithDictionary:tempProducts];

    NSDictionary *questionsDict = apiResponse[@"Questions"];
    NSMutableDictionary<NSString *, BVQuestion *> *tempQuestions =
        [NSMutableDictionary dictionary];
    for (NSString *key in questionsDict) {
      tempQuestions[key] =
          [[BVQuestion alloc] initWithApiResponse:questionsDict[key]
                                         includes:nil];
    }
    self.questionsDict = [NSDictionary dictionaryWithDictionary:tempQuestions];

    NSDictionary *reviewsDict = apiResponse[@"Reviews"];
    NSMutableDictionary<NSString *, BVReview *> *tempReviews =
        [NSMutableDictionary dictionary];
    for (NSString *key in reviewsDict) {
      tempReviews[key] =
          [[BVReview alloc] initWithApiResponse:reviewsDict[key] includes:nil];
    }
    self.reviewsDict = [NSDictionary dictionaryWithDictionary:tempReviews];
  }
  return self;
}

@end
