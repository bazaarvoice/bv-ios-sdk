//
//  ConversationsInclude.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVProduct.h"
#import "BVAnswer.h"
#import "BVQuestion.h"
#import "BVReview.h"

/// Internal utility - used only within BVSDK
@interface BVConversationsInclude : NSObject

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse;

-(BVAnswer* _Nullable)getAnswerById:(NSString* _Nonnull)answerId;
-(BVProduct* _Nullable)getProductById:(NSString* _Nonnull)productId;
-(BVReview* _Nullable)getReviewById:(NSString* _Nonnull)reviewId;
-(BVQuestion* _Nullable)getQuestionById:(NSString* _Nonnull)questionId;

@property (nonatomic, strong, readonly) NSDictionary  * _Nonnull apiResponse;

@end
