//
//  BVQuestionsSortOptionValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVQUESTIONSSORTOPTIONVALUE_H
#define BVQUESTIONSSORTOPTIONVALUE_H

/*
 The allowable sort types for `BVQuestionsAndAnswersRequests` requests.
 */
typedef NS_ENUM(NSInteger, BVQuestionsSortOptionValue) {
  BVQuestionsSortOptionValueQuestionId,
  BVQuestionsSortOptionValueQuestionAuthorId,
  BVQuestionsSortOptionValueQuestionCampaignId,
  BVQuestionsSortOptionValueQuestionContentLocale,
  BVQuestionsSortOptionValueQuestionHasAnswers,
  BVQuestionsSortOptionValueQuestionHasBestAnswer,
  BVQuestionsSortOptionValueQuestionHasPhotos,
  BVQuestionsSortOptionValueQuestionHasStaffAnswers,
  BVQuestionsSortOptionValueQuestionIsFeatured,
  BVQuestionsSortOptionValueQuestionIsSubjectActive,
  BVQuestionsSortOptionValueQuestionLastApprovedAnswerSubmissionTime,
  BVQuestionsSortOptionValueQuestionModeratorCode,
  BVQuestionsSortOptionValueQuestionLastModeratedTime,
  BVQuestionsSortOptionValueQuestionLastModificationTime,
  BVQuestionsSortOptionValueQuestionProductId,
  BVQuestionsSortOptionValueQuestionSubmissionId,
  BVQuestionsSortOptionValueQuestionSubmissionTime,
  BVQuestionsSortOptionValueQuestionSummary,
  BVQuestionsSortOptionValueQuestionTotalAnswerCount,
  BVQuestionsSortOptionValueQuestionTotalFeedbackCount,
  BVQuestionsSortOptionValueQuestionTotalNegativeFeedbackCount,
  BVQuestionsSortOptionValueQuestionTotalPositiveFeedbackCount,
  BVQuestionsSortOptionValueQuestionUserLocation,
  BVQuestionsSortOptionValueQuestionHasVideos, // PRR Only
};

#endif /* BVQUESTIONSSORTOPTIONVALUE_H */
