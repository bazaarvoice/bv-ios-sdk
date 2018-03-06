//
//  BVQuestionFilterValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVQUESTIONFILTERVALUE_H
#define BVQUESTIONFILTERVALUE_H

/*
 The allowable filter types for `BVQuestionsAndAnswersRequest` requests.
 */
typedef NS_ENUM(NSInteger, BVQuestionFilterValue) {
  BVQuestionFilterValueQuestionId,
  BVQuestionFilterValueQuestionAuthorId,
  BVQuestionFilterValueQuestionCampaignId,
  BVQuestionFilterValueQuestionCategoryAncestorId,
  BVQuestionFilterValueQuestionCategoryId,
  BVQuestionFilterValueQuestionContentLocale,
  BVQuestionFilterValueQuestionHasAnswers,
  BVQuestionFilterValueQuestionHasBestAnswer,
  BVQuestionFilterValueQuestionHasBrandAnswers,
  BVQuestionFilterValueQuestionHasPhotos,
  BVQuestionFilterValueQuestionHasStaffAnswers,
  BVQuestionFilterValueQuestionHasTags,
  BVQuestionFilterValueQuestionHasVideos,
  BVQuestionFilterValueQuestionIsFeatured,
  BVQuestionFilterValueQuestionIsSubjectActive,
  BVQuestionFilterValueQuestionLastApprovedAnswerSubmissionTime,
  BVQuestionFilterValueQuestionLastModeratedTime,
  BVQuestionFilterValueQuestionLastModificationTime,
  BVQuestionFilterValueQuestionModeratorCode,
  BVQuestionFilterValueQuestionProductId,
  BVQuestionFilterValueQuestionSubmissionId,
  BVQuestionFilterValueQuestionSubmissionTime,
  BVQuestionFilterValueQuestionSummary,
  BVQuestionFilterValueQuestionTotalAnswerCount,
  BVQuestionFilterValueQuestionTotalFeedbackCount,
  BVQuestionFilterValueQuestionTotalNegativeFeedbackCount,
  BVQuestionFilterValueQuestionTotalPositiveFeedbackCount,
  BVQuestionFilterValueQuestionUserLocation
};

#endif /* BVQUESTIONFILTERVALUE_H */
