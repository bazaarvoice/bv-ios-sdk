//
//  BVSortOptionAnswers.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The allowable sorting types for answers included in a `BVQuestionsAndAnswersRequest` request.
 */
typedef NS_ENUM(NSInteger, BVSortOptionAnswers) {
    BVSortOptionAnswersId,
    BVSortOptionAnswersAuthorId,
    BVSortOptionAnswersCampaignId,
    BVSortOptionAnswersContentLocale,
    BVSortOptionAnswersHasPhotos,
    BVSortOptionAnswersIsBestAnswer,
    BVSortOptionAnswersIsFeatured,
    BVSortOptionAnswersLastModeratedTime,
    BVSortOptionAnswersLastModificationTime,
    BVSortOptionAnswersProductId,
    BVSortOptionAnswersQuestionId,
    BVSortOptionAnswersSubmissionId,
    BVSortOptionAnswersSubmissionTime,
    BVSortOptionAnswersTotalFeedbackCount,
    BVSortOptionAnswersTotalNegativeFeedbackCount,
    BVSortOptionAnswersTotalPositiveFeedbackCount,
    BVSortOptionAnswersUserLocation
};

@interface BVSortOptionAnswersUtil : NSObject

+(NSString* _Nonnull)toString:(BVSortOptionAnswers)BVSortOptionAnswers;

@end