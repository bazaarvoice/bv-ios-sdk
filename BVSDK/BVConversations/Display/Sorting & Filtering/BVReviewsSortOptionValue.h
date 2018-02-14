//
//  BVReviewsSortOptionValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVREVIEWSSORTOPTIONVALUE_H
#define BVREVIEWSSORTOPTIONVALUE_H

/*
 The allowable sort types for `BVReviewsRequest` requests.
 */
typedef NS_ENUM(NSInteger, BVReviewsSortOptionValue) {
  BVReviewsSortOptionValueReviewId,
  BVReviewsSortOptionValueReviewAuthorId,
  BVReviewsSortOptionValueReviewCampaignId,
  BVReviewsSortOptionValueReviewContentLocale,
  BVReviewsSortOptionValueReviewHasComments,
  BVReviewsSortOptionValueReviewHasPhotos,
  BVReviewsSortOptionValueReviewHasTags,
  BVReviewsSortOptionValueReviewHasVideos,
  BVReviewsSortOptionValueReviewHelpfulness,
  BVReviewsSortOptionValueReviewIsFeatured,
  BVReviewsSortOptionValueReviewIsRatingsOnly,
  BVReviewsSortOptionValueReviewIsRecommended,
  BVReviewsSortOptionValueReviewIsSubjectActive,
  BVReviewsSortOptionValueReviewIsSyndicated,
  BVReviewsSortOptionValueReviewLastModeratedTime,
  BVReviewsSortOptionValueReviewLastModificationTime,
  BVReviewsSortOptionValueReviewProductId,
  BVReviewsSortOptionValueReviewRating,
  BVReviewsSortOptionValueReviewSubmissionId,
  BVReviewsSortOptionValueReviewSubmissionTime,
  BVReviewsSortOptionValueReviewTotalCommentCount,
  BVReviewsSortOptionValueReviewTotalFeedbackCount,
  BVReviewsSortOptionValueReviewTotalNegativeFeedbackCount,
  BVReviewsSortOptionValueReviewTotalPositiveFeedbackCount,
  BVReviewsSortOptionValueReviewUserLocation
};

#endif /* BVREVIEWSSORTOPTIONVALUE_H */
