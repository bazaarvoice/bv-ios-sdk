//
//  ConversationsInclude.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswer.h"
#import "BVAuthor.h"
#import "BVComment.h"
#import "BVNullHelper.h"
#import "BVProduct.h"
#import "BVQuestion.h"
#import "BVReview.h"
#import <Foundation/Foundation.h>

#define GET_BVOBJECTS_FROM_CONVERSATIONS_INCLUDE(ASSIGN, INCLUDES, OBJECTID)   \
                                                                               \
  NSMutableArray<BV##OBJECTID *> *temp##OBJECTID##s = [NSMutableArray array];  \
  id OBJECTID##Identifier =                                                    \
      apiResponse[[NSString stringWithFormat:@"%@Id", @ #OBJECTID]]            \
          ?: apiResponse[[NSString stringWithFormat:@"%@Ids", @ #OBJECTID]];   \
  if (__IS_KIND_OF(OBJECTID##Identifier, NSArray<NSString *>)) {               \
    NSArray<NSString *> *objectIds =                                           \
        (NSArray<NSString *> *)OBJECTID##Identifier;                           \
    for (NSString * objectId in objectIds) {                                   \
      BV##OBJECTID *object = [INCLUDES get##OBJECTID##ById:objectId];          \
      if (object) {                                                            \
        [temp##OBJECTID##s addObject:object];                                  \
      }                                                                        \
    }                                                                          \
  } else if (__IS_KIND_OF(OBJECTID##Identifier, NSString)) {                   \
    NSString *objectId = (NSString *)OBJECTID##Identifier;                     \
    BV##OBJECTID *object = [INCLUDES get##OBJECTID##ById:objectId];            \
    if (object) {                                                              \
      [temp##OBJECTID##s addObject:object];                                    \
    }                                                                          \
  } else {                                                                     \
    [temp##OBJECTID##s addObjectsFromArray:[INCLUDES get##OBJECTID##s]];       \
  }                                                                            \
  ASSIGN = temp##OBJECTID##s

@interface BVConversationsInclude : NSObject

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

- (nullable BVAnswer *)getAnswerById:(nonnull NSString *)answerId;
- (nonnull NSArray<BVAnswer *> *)getAnswers;

- (nullable BVAuthor *)getAuthorById:(nonnull NSString *)authorId;
- (nonnull NSArray<BVAuthor *> *)getAuthors;

- (nullable BVComment *)getCommentById:(nonnull NSString *)commentId;
- (nonnull NSArray<BVComment *> *)getComments;

- (nullable BVProduct *)getProductById:(nonnull NSString *)productId;
- (nonnull NSArray<BVProduct *> *)getProducts;

- (nullable BVQuestion *)getQuestionById:(nonnull NSString *)questionId;
- (nonnull NSArray<BVQuestion *> *)getQuestions;

- (nullable BVReview *)getReviewById:(nonnull NSString *)reviewId;
- (nonnull NSArray<BVReview *> *)getReviews;

@property(nonnull, nonatomic, strong, readonly) NSDictionary *apiResponse;

@end
