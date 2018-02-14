//
//  BVProductsSortOptionValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVPRODUCTSSORTOPTIONVALUE_H
#define BVPRODUCTSSORTOPTIONVALUE_H

/*
 The allowable sort types for `BVReviewsRequest` and
 `BVQuestionsAndAnswersRequests` requests.
 */
typedef NS_ENUM(NSInteger, BVProductsSortOptionValue) {
  BVProductsSortOptionValueProductId,
  BVProductsSortOptionValueProductAverageOverallRating,
  BVProductsSortOptionValueProductRating,
  BVProductsSortOptionValueProductCategoryId,
  BVProductsSortOptionValueProductIsActive,
  BVProductsSortOptionValueProductIsDisabled,
  BVProductsSortOptionValueProductLastAnswerTime,
  BVProductsSortOptionValueProductLastQuestionTime,
  BVProductsSortOptionValueProductLastReviewTime,
  BVProductsSortOptionValueProductLastStoryTime,
  BVProductsSortOptionValueProductName,
  BVProductsSortOptionValueProductRatingsOnlyReviewCount,
  BVProductsSortOptionValueProductTotalAnswerCount,
  BVProductsSortOptionValueProductTotalQuestionCount,
  BVProductsSortOptionValueProductTotalReviewCount,
  BVProductsSortOptionValueProductTotalStoryCount,
  BVProductsSortOptionValueProductHelpfulness
};

#endif /* BVPRODUCTSSORTOPTIONVALUE_H */
