//
//  BVSortOptionProducts.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The allowable sort types for `BVReviewsRequest` and
 `BVQuestionsAndAnswersRequests` requests.
 */
typedef NS_ENUM(NSInteger, BVSortOptionProducts) {
  BVSortOptionProductsId,
  BVSortOptionProductsAverageOverallRating,
  BVSortOptionProductsRating,
  BVSortOptionProductsCategoryId,
  BVSortOptionProductsIsActive,
  BVSortOptionProductsIsDisabled,
  BVSortOptionProductsLastAnswerTime,
  BVSortOptionProductsLastQuestionTime,
  BVSortOptionProductsLastReviewTime,
  BVSortOptionProductsLastStoryTime,
  BVSortOptionProductsName,
  BVSortOptionProductsRatingsOnlyReviewCount,
  BVSortOptionProductsTotalAnswerCount,
  BVSortOptionProductsTotalQuestionCount,
  BVSortOptionProductsTotalReviewCount,
  BVSortOptionProductsTotalStoryCount,
  BVSortOptionProductsHelpfulness
};

@interface BVSortOptionProductsUtil : NSObject

+ (nonnull NSString *)toString:(BVSortOptionProducts)BVSortOptionProducts;

@end
