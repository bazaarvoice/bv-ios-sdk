//
//  ConversationsInclude.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswer.h"
#import "BVAuthor.h"
#import "BVComment.h"
#import "BVProduct.h"
#import "BVQuestion.h"
#import "BVReview.h"
#import <Foundation/Foundation.h>

/// Internal utility - used only within BVSDK
@interface BVConversationsInclude : NSObject

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

- (nullable BVAnswer *)getAnswerById:(nonnull NSString *)answerId;
- (nullable BVProduct *)getProductById:(nonnull NSString *)productId;
- (nullable BVReview *)getReviewById:(nonnull NSString *)reviewId;
- (nullable BVQuestion *)getQuestionById:(nonnull NSString *)questionId;
- (nullable BVComment *)getCommentById:(nonnull NSString *)commentId;
- (nullable BVAuthor *)getAuthorById:(nonnull NSString *)authorId;

@property(nonnull, nonatomic, strong, readonly) NSDictionary *apiResponse;

@end
