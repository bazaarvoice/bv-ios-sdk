//
//  BVSortOptionQuestions.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The allowable sort types for `BVQuestionsAndAnswersRequests` requests.
 */
typedef NS_ENUM(NSInteger, BVSortOptionQuestions) {
    BVSortOptionQuestionsId,
    BVSortOptionQuestionsAuthorId,
    BVSortOptionQuestionsCampaignId,
    BVSortOptionQuestionsContentLocale,
    BVSortOptionQuestionsHasAnswers,
    BVSortOptionQuestionsHasBestAnswer,
    BVSortOptionQuestionsHasPhotos,
    BVSortOptionQuestionsHasStaffAnswers,
    BVSortOptionQuestionsHasVideos,
    BVSortOptionQuestionsIsFeatured,
    BVSortOptionQuestionsIsSubjectActive,
    BVSortOptionQuestionsLastApprovedAnswerSubmissionTime,
    BVSortOptionQuestionsLastModeratedTime,
    BVSortOptionQuestionsLastModificationTime,
    BVSortOptionQuestionsProductId,
    BVSortOptionQuestionsSubmissionId,
    BVSortOptionQuestionsSubmissionTime,
    BVSortOptionQuestionsSummary,
    BVSortOptionQuestionsTotalAnswerCount,
    BVSortOptionQuestionsTotalFeedbackCount,
    BVSortOptionQuestionsTotalNegativeFeedbackCount,
    BVSortOptionQuestionsTotalPositiveFeedbackCount,
    BVSortOptionQuestionsUserLocation
};

@interface BVSortOptionQuestionsUtil : NSObject

+(NSString* _Nonnull)toString:(BVSortOptionQuestions)BVSortOptionQuestions;

@end