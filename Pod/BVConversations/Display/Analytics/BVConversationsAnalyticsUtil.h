//
//  ConversationsAnalyticsUtil.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BVProduct;
@class BVQuestion;
@class BVReview;
@class BVAnswer;
@class BVReviewSubmission;
@class BVQuestionSubmission;
@class BVAnswerSubmission;
@class BVFeedbackSubmission;
@class BVStore;

/// Internal enum - used only within BVSDK
typedef enum {
    ScrollTypeReviewsTable,
    ScrollTypeReviewsCollectionView,
    ScrollTypeQuestionsTable,
    ScrollTypeQuestionsCollectionView,
    ScrollTypeAnswersTable,
    ScrollTypeAnswersCollectionView
} ScrollType;

/*
 Internal class - used only within BVSDK
 */
@interface BVConversationsAnalyticsUtil : NSObject

+(nonnull NSDictionary*)reviewAnalyticsEvents:(nonnull BVReview*)review;
+(nonnull NSArray<NSDictionary*>*)questionAnalyticsEvents:(nonnull BVQuestion*)question;
+(nonnull NSArray<NSDictionary*>*)productAnalyticsEvents:(nonnull BVProduct*)product;

+(void)queueAnalyticsEventForUGCScrollEvent:(ScrollType)type productId:(NSString * _Nullable)productId;
+(void)queueAnalyticsEventForProductPageView:(nullable BVProduct*)product;
+(void)queueAnalyticsEventForProductPageView:(nullable NSString*)productId numReviews:(nullable NSNumber*)numReviews numQuestions:(nullable NSNumber*)numQuestions;

+(void)queueAnalyticsEventForReviewContainerInView:(NSString * _Nullable)productId;
+(void)queueAnalyticsEventForQuestionContainerInView:(NSString * _Nullable)productId;
+(void)queueAnalyticsEventForAnswerContainerInView:(NSString * _Nullable)productId;

+(void)queueAnalyticsEventForReviewSubmission:(nonnull BVReviewSubmission *)reviewSubmission;
+(void)queueAnalyticsEventForQuestionSubmission:(nonnull BVQuestionSubmission *)questionSubmission;
+(void)queueAnalyticsEventForAnswerSubmission:(nonnull BVAnswerSubmission *)answerSubmission;
+(void)queueAnalyticsEventForFeedbackSubmission:(nonnull BVFeedbackSubmission *)feedbackSubmission;
+(void)queueAnalyticsEventForPhotoSubmission;
    
+(void)queueAnalyticsEventForStorePageView:(BVStore* _Nullable)store;


@end
