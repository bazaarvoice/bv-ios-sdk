//
//  BVAnswersSortOptionValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVANSWERSSORTOPTIONVALUE_H
#define BVANSWERSSORTOPTIONVALUE_H

/*
 The allowable sorting types for answers included in a
 `BVQuestionsAndAnswersRequest` request.
 */
typedef NS_ENUM(NSInteger, BVAnswersSortOptionValue) {
  BVAnswersSortOptionValueAnswerId,
  BVAnswersSortOptionValueAnswerAuthorId,
  BVAnswersSortOptionValueAnswerCampaignId,
  BVAnswersSortOptionValueAnswerContentLocale,
  BVAnswersSortOptionValueAnswerHasPhotos,
  BVAnswersSortOptionValueAnswerIsBestAnswer,
  BVAnswersSortOptionValueAnswerIsFeatured,
  BVAnswersSortOptionValueAnswerLastModeratedTime,
  BVAnswersSortOptionValueAnswerLastModificationTime,
  BVAnswersSortOptionValueAnswerProductId,
  BVAnswersSortOptionValueAnswerQuestionId,
  BVAnswersSortOptionValueAnswerSubmissionId,
  BVAnswersSortOptionValueAnswerSubmissionTime,
  BVAnswersSortOptionValueAnswerTotalFeedbackCount,
  BVAnswersSortOptionValueAnswerTotalNegativeFeedbackCount,
  BVAnswersSortOptionValueAnswerTotalPositiveFeedbackCount,
  BVAnswersSortOptionValueAnswerUserLocation
};

#endif /* BVANSWERSSORTOPTIONVALUE_H */
