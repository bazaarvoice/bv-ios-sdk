//
//  ConversationsAnalyticsUtil.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationsAnalyticsUtil.h"
#import "BVAnalyticsManager.h"
#import "BVProduct.h"
#import "BVReview.h"
#import "BVQuestion.h"
#import "BVAnswer.h"
#import "BVReviewSubmission.h"
#import "BVQuestionSubmission.h"
#import "BVAnswerSubmission.h"
#import "BVFeedbackSubmission.h"

@implementation BVConversationsAnalyticsUtil

+(NSDictionary* _Nonnull)reviewAnalyticsEvents:(BVReview* _Nonnull)review {
    
    NSMutableDictionary* impressionEvent = [NSMutableDictionary dictionary];
    impressionEvent[@"cl"] = @"Impression";
    impressionEvent[@"type"] = @"UGC";
    impressionEvent[@"bvProduct"] = [self reviewsProductName];
    impressionEvent[@"source"] = @"native-mobile-sdk";
    impressionEvent[@"contentType"] = @"Review";
    impressionEvent[@"contentId"] = review.identifier;
    impressionEvent[@"productId"] = review.productId;
    return impressionEvent;
    
}

+(NSArray<NSDictionary*>* _Nonnull)questionAnalyticsEvents:(BVQuestion* _Nonnull)question {
    
    NSMutableArray* events = [NSMutableArray array];
    
    NSMutableDictionary* impressionEvent = [NSMutableDictionary dictionary];
    impressionEvent[@"cl"] = @"Impression";
    impressionEvent[@"type"] = @"UGC";
    impressionEvent[@"bvProduct"] = [self reviewsProductName];
    impressionEvent[@"source"] = @"native-mobile-sdk";
    impressionEvent[@"contentType"] = @"Question";
    impressionEvent[@"contentId"] = question.identifier;
    impressionEvent[@"productId"] = question.productId;
    [events addObject:impressionEvent];
    
    for (BVAnswer* answer in question.answers) {
        NSMutableDictionary* answerImpression = [NSMutableDictionary dictionary];
        answerImpression[@"cl"] = @"Impression";
        answerImpression[@"type"] = @"UGC";
        answerImpression[@"bvProduct"] = [self reviewsProductName];
        answerImpression[@"source"] = @"native-mobile-sdk";
        answerImpression[@"contentType"] = @"Answer";
        answerImpression[@"contentId"] = answer.identifier;
        answerImpression[@"productId"] = question.productId;
        [events addObject:answerImpression];
    }
    
    return events;
    
}

+(NSArray<NSDictionary*>* _Nonnull)productAnalyticsEvents:(BVProduct* _Nonnull)product {
    
    NSMutableArray* events = [NSMutableArray array];

    for(BVReview* review in product.includedReviews) {
        [events addObject:[BVConversationsAnalyticsUtil reviewAnalyticsEvents:review]];
    }
    
    for(BVQuestion* question in product.includedQuestions) {
        [events addObjectsFromArray:[BVConversationsAnalyticsUtil questionAnalyticsEvents:question]];
    }
    
    return events;
    
}

+(NSString*)scrollTypeToString:(ScrollType)type {
    switch (type) {
        case ScrollTypeAnswersTable:
            return @"AnswersTable";
        case ScrollTypeReviewsTable:
            return @"ReviewsTable";
        case ScrollTypeQuestionsTable:
            return @"QuestionsTable";
        case ScrollTypeAnswersCollectionView:
            return @"AnswersCollectionView";
        case ScrollTypeReviewsCollectionView:
            return @"ReviewsCollectionView";
        case ScrollTypeQuestionsCollectionView:
            return @"QuestionsCollectionView";
    }
}

+(void)queueAnalyticsEventForUGCScrollEvent:(ScrollType)type  productId:(NSString * _Nullable)productId {
    
    NSMutableDictionary* event = [self usedFeatureEvent];
    event[@"component"] = [self scrollTypeToString:type];
    event[@"name"] = @"Scrolled";
    
    switch (type) {
        case ScrollTypeReviewsTable:
        case ScrollTypeReviewsCollectionView:
        default:
            event[@"bvProduct"] = [self reviewsProductName];
            break;
         
        case ScrollTypeQuestionsTable:
        case ScrollTypeQuestionsCollectionView:
        case ScrollTypeAnswersTable:
        case ScrollTypeAnswersCollectionView:
            event[@"bvProduct"] = [self questionsAnswersProductName];
            break;
            
    }
    
    if (productId){
        event[@"productId"] = productId;
    }
    
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}

+(void)queueAnalyticsEventForProductPageView:(BVProduct* _Nullable)product {
    
    if(product == nil) {
        return;
    }
    
    NSMutableDictionary* event = [self productPageViewEvent];
    event[@"productId"] = product.identifier;
    event[@"categoryId"] = product.categoryId;
    event[@"numReview"] = [NSString stringWithFormat:@"%lu", (unsigned long)[product.includedReviews count]];
    event[@"numQuestions"] = [NSString stringWithFormat:@"%lu", (unsigned long)[product.includedQuestions count]];
    [[BVAnalyticsManager sharedManager] queuePageViewEventDict:event];

}
    
+(void)queueAnalyticsEventForStorePageView:(BVStore* _Nullable)store {
    
    if(store == nil) {
        return;
    }
    
    NSMutableDictionary* event = [self productPageViewEvent];
    event[@"productId"] = store.identifier;
    event[@"categoryId"] = store.categoryId;
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}


+(void)queueAnalyticsEventForProductPageView:(nullable NSString*)productId numReviews:(nullable NSNumber*)numReviews numQuestions:(nullable NSNumber*)numQuestions {
    
    if(productId == nil) {
        return;
    }
    
    NSMutableDictionary* event = [self productPageViewEvent];
    event[@"productId"] = productId;
    if (numReviews != nil) {
        event[@"numReview"] = [NSString stringWithFormat:@"%li", [numReviews longValue]];
    }
    if (numQuestions != nil) {
        event[@"numQuestions"] = [NSString stringWithFormat:@"%li", [numQuestions longValue]];
    }
    [[BVAnalyticsManager sharedManager] queuePageViewEventDict:event];
    
}

+(void)queueAnalyticsEventForReviewContainerInView:(NSString * _Nullable)productId {

    NSMutableDictionary* event = [self usedFeatureInViewEvent];
    event[@"bvProduct"] = [self reviewsProductName];
    if (productId){
        event[@"productId"] = productId;
    }
    [[BVAnalyticsManager sharedManager] queueEvent:event];

}

+(void)queueAnalyticsEventForQuestionContainerInView:(NSString * _Nullable)productId {

    NSMutableDictionary* event = [self usedFeatureInViewEvent];
    event[@"bvProduct"] = [self questionsAnswersProductName];
    if (productId){
        event[@"productId"] = productId;
    }
    [[BVAnalyticsManager sharedManager] queueEvent:event];

}

+(void)queueAnalyticsEventForAnswerContainerInView:(NSString * _Nullable)productId {
    
    NSMutableDictionary* event = [self usedFeatureInViewEvent];
    event[@"bvProduct"] = [self questionsAnswersProductName];
    if (productId){
        event[@"productId"] = productId;
    }
    [[BVAnalyticsManager sharedManager] queueEvent:event];

}


+(void)queueAnalyticsEventForReviewSubmission:(BVReviewSubmission *)reviewSubmission {
    
    bool isFingerprinting = reviewSubmission.fingerPrint != nil;
    [self processAndSendSubmissionEvent:@"Write" productId:reviewSubmission.productId fingerPrinting:isFingerprinting];
    
}

+(void)queueAnalyticsEventForQuestionSubmission:(BVQuestionSubmission *)questionSubmission {
    
    bool isFingerprinting = questionSubmission.fingerPrint != nil;
    [self processAndSendSubmissionEvent:@"Ask" productId:questionSubmission.productId fingerPrinting:isFingerprinting];
    
}

+(void)queueAnalyticsEventForAnswerSubmission:(nonnull BVAnswerSubmission *)answerSubmission {
    
    bool isFingerprinting = answerSubmission.fingerPrint != nil;
    [self processAndSendSubmissionEvent:@"Answer" productId:nil fingerPrinting:isFingerprinting];
    
}

+(void)queueAnalyticsEventForFeedbackSubmission:(nonnull BVFeedbackSubmission *)feedbackSubmission{
    
    bool isFingerprinting = false; // no fingerprinting for Feedback
    
    NSMutableDictionary* event = [self usedFeatureEvent];
    
    event[@"bvProduct"] = [self reviewsProductName];
    event[@"name"] = @"Feedback";
    event[@"contentId"] = feedbackSubmission.contentId;
    event[@"fingerprinting"] = isFingerprinting ? @"true" : @"false";
    
    if (feedbackSubmission.contentType == BVFeedbackContentTypeReview){
        event[@"contenttype"] = @"review";
    } else if (feedbackSubmission.contentType == BVFeedbackContentTypeQuestion){
        event[@"contenttype"] = @"question";
    } else if (feedbackSubmission.contentType == BVFeedbackContentTypeAnswer){
        event[@"contenttype"] = @"answer";
    }
    
    if (feedbackSubmission.feedbackType == BVFeedbackTypeHelpfulness){
        event[@"detail1"] = @"helpfulness";
    } else if (feedbackSubmission.feedbackType == BVFeedbackTypeInappropriate){
        event[@"detail1"] = @"inappropriate";
    }
    
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}

+(void)processAndSendSubmissionEvent:(nonnull NSString*)name productId:(nullable NSString*)productId fingerPrinting:(bool)isFingerprinting {
    
    NSMutableDictionary* event = [self usedFeatureEvent];
    
    event[@"name"] = name;
    event[@"productId"] = productId;
    event[@"fingerprinting"] = isFingerprinting ? @"true" : @"false";
    
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}

+(void)queueAnalyticsEventForPhotoSubmission {
    
    NSMutableDictionary* event = [self usedFeatureEvent];
    event[@"bvProduct"] = [self questionsAnswersProductName];
    event[@"name"] = @"Photo";
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}

+(NSString*)reviewsProductName {
    return @"RatingsAndReviews";
}
+(NSString*)questionsAnswersProductName {
    return @"AskAndAnswer";
}

+(NSMutableDictionary*)usedFeatureEvent {
    return [NSMutableDictionary dictionaryWithDictionary:@{
             @"cl": @"Feature",
             @"type": @"Used",
             @"source": @"native-mobile-sdk"
             }];
}

+(NSMutableDictionary*)productPageViewEvent {
    return [NSMutableDictionary dictionaryWithDictionary:@{
           @"type": @"Product",
           @"cl": @"PageView",
           @"source": @"native-mobile-sdk",
           @"bvProduct": [self reviewsProductName]
           }];
}


+(NSMutableDictionary*)usedFeatureInViewEvent {
    
    NSMutableDictionary* event = [self usedFeatureEvent];
    event[@"name"] = @"InView";
    event[@"interaction"] = @"false";
    return event;
    
}

+(NSDictionary*)reviewInfo:(BVReview*)review {

    NSMutableDictionary* info = [NSMutableDictionary dictionary];
    info[@"bvProduct"] = [self reviewsProductName];
    info[@"productId"] = review.productId;
    if (review.product != nil) {
        info[@"categoryId"] = review.product.categoryId;
    }
    info[@"detail1"] = review.identifier;
    return info;

}

+(NSDictionary*)questionInfo:(BVQuestion*)question {
    
    NSMutableDictionary* info = [NSMutableDictionary dictionary];
    info[@"bvProduct"] = [self questionsAnswersProductName];
    info[@"productId"] = question.productId;
    info[@"detail1"] = question.identifier;
    return info;
    
}

+(NSDictionary*)answerInfo:(BVAnswer*)answer {
    
    NSMutableDictionary* info = [NSMutableDictionary dictionary];
    info[@"bvProduct"] = [self questionsAnswersProductName];
    info[@"detail1"] = answer.identifier;
    info[@"detail2"] = answer.questionId;
    return info;
    
}
@end
