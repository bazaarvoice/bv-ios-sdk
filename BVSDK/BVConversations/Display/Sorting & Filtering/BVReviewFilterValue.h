//
//  BVReviewFilterValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVREVIEWFILTERVALUE_H
#define BVREVIEWFILTERVALUE_H

/**
 The allowable filter types for `BVReviewsRequest` requests.
 */
typedef NS_ENUM(NSInteger, BVReviewFilterValue) {
  BVReviewFilterValueId,
  BVReviewFilterValueAuthorId,
  BVReviewFilterValueCampaignId,
  BVReviewFilterValueCategoryAncestorId,
  BVReviewFilterValueContentLocale,
  BVReviewFilterValueHasComments,
  BVReviewFilterValueHasPhotos,
  BVReviewFilterValueHasTags,
  BVReviewFilterValueHasVideos,
  BVReviewFilterValueIsFeatured,
  BVReviewFilterValueIsRatingsOnly,
  BVReviewFilterValueIsRecommended,
  BVReviewFilterValueIsSubjectActive,
  BVReviewFilterValueIsSyndicated,
  BVReviewFilterValueLastModeratedTime,
  BVReviewFilterValueLastModificationTime,
  BVReviewFilterValueModeratorCode,
  BVReviewFilterValueProductId,
  BVReviewFilterValueRating,
  BVReviewFilterValueSubmissionId,
  BVReviewFilterValueSubmissionTime,
  BVReviewFilterValueTotalCommentCount,
  BVReviewFilterValueTotalFeedbackCount,
  BVReviewFilterValueTotalNegativeFeedbackCount,
  BVReviewFilterValueTotalPositiveFeedbackCount,
  BVReviewFilterValueUserLocation
};

#endif /* BVREVIEWFILTERVALUE_H */
