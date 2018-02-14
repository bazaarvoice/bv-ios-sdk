//
//  BVProductFilterValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVPRODUCTFILTERVALUE_H
#define BVPRODUCTFILTERVALUE_H

/*
 The allowable filter types for `BVProductDisplayPageRequest` requests.
 */
typedef NS_ENUM(NSInteger, BVProductFilterValue) {
  BVProductFilterValueProductId,
  BVProductFilterValueProductAverageOverallRating,
  BVProductFilterValueProductCategoryAncestorId,
  BVProductFilterValueProductCategoryId,
  BVProductFilterValueProductIsActive,
  BVProductFilterValueProductIsDisabled,
  BVProductFilterValueProductLastAnswerTime,
  BVProductFilterValueProductLastQuestionTime,
  BVProductFilterValueProductLastReviewTime,
  BVProductFilterValueProductLastStoryTime,
  BVProductFilterValueProductName,
  BVProductFilterValueProductRatingsOnlyReviewCount,
  BVProductFilterValueProductTotalAnswerCount,
  BVProductFilterValueProductTotalQuestionCount,
  BVProductFilterValueProductTotalReviewCount,
  BVProductFilterValueProductTotalStoryCount
};

#endif /* BVPRODUCTFILTERVALUE_H */
