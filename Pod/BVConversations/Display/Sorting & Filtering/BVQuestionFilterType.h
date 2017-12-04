//
//  BVQuestionFilterType.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The allowable filter types for `BVQuestionsAndAnswersRequest` requests.
 */
typedef NS_ENUM(NSInteger, BVQuestionFilterType) {
  BVQuestionFilterTypeId,
  BVQuestionFilterTypeAuthorId,
  BVQuestionFilterTypeCampaignId,
  BVQuestionFilterTypeCategoryAncestorId,
  BVQuestionFilterTypeCategoryId,
  BVQuestionFilterTypeContentLocale,
  BVQuestionFilterTypeHasAnswers,
  BVQuestionFilterTypeHasBestAnswer,
  BVQuestionFilterTypeHasBrandAnswers,
  BVQuestionFilterTypeHasPhotos,
  BVQuestionFilterTypeHasStaffAnswers,
  BVQuestionFilterTypeHasTags,
  BVQuestionFilterTypeHasVideos,
  BVQuestionFilterTypeIsFeatured,
  BVQuestionFilterTypeIsSubjectActive,
  BVQuestionFilterTypeLastApprovedAnswerSubmissionTime,
  BVQuestionFilterTypeLastModeratedTime,
  BVQuestionFilterTypeLastModificationTime,
  BVQuestionFilterTypeModeratorCode,
  BVQuestionFilterTypeSubmissionId,
  BVQuestionFilterTypeSubmissionTime,
  BVQuestionFilterTypeSummary,
  BVQuestionFilterTypeTotalAnswerCount,
  BVQuestionFilterTypeTotalFeedbackCount,
  BVQuestionFilterTypeTotalNegativeFeedbackCount,
  BVQuestionFilterTypeTotalPositiveFeedbackCount,
  BVQuestionFilterTypeUserLocation
};

@interface BVQuestionFilterTypeUtil : NSObject

+ (nonnull NSString *)toString:(BVQuestionFilterType)filterOperator;

@end
