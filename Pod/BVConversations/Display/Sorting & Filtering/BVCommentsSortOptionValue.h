//
//  BVCommentsSortOptionValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVCOMMENTSSORTOPTIONVALUE_H
#define BVCOMMENTSSORTOPTIONVALUE_H

/**
 The allowable sort types for `BVCommentsRequest` requests.
 API Reference:
 https://developer.bazaarvoice.com/conversations-api/reference/v5.4/comments/comment-display#sort-options
 */
typedef NS_ENUM(NSInteger, BVCommentsSortOptionValue) {
  BVCommentsSortOptionValueCommentId,
  BVCommentsSortOptionValueCommentAuthorId,
  BVCommentsSortOptionValueCommentCampaignId,
  BVCommentsSortOptionValueCommentContentLocale,
  BVCommentsSortOptionValueCommentIsFeatured,
  BVCommentsSortOptionValueCommentLastModeratedTime,
  BVCommentsSortOptionValueCommentLastModificationTime,
  BVCommentsSortOptionValueCommentProductId,
  BVCommentsSortOptionValueCommentReviewId,
  BVCommentsSortOptionValueCommentSubmissionId,
  BVCommentsSortOptionValueCommentSubmissionTime,
  BVCommentsSortOptionValueCommentTotalFeedbackCount,
  BVCommentsSortOptionValueCommentTotalNegativeFeedbackCount,
  BVCommentsSortOptionValueCommentTotalPositiveFeedbackCount,
  BVCommentsSortOptionValueCommentUserLocation
};

#endif /* BVCOMMENTSSORTOPTIONVALUE_H */
