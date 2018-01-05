//
//  BVCommentFilterValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVCOMMENTFILTERVALUE_H
#define BVCOMMENTFILTERVALUE_H

/**
 The allowable filter types for `BVCommentsRequest` requests.
 API Refernce:
 https://developer.bazaarvoice.com/conversations-api/reference/v5.4/comments/comment-display#filter-options
 */
typedef NS_ENUM(NSInteger, BVCommentFilterValue) {
  BVCommentFilterValueCommentId,
  BVCommentFilterValueCommentAuthorId,
  BVCommentFilterValueCommentCampaignId,
  BVCommentFilterValueCommentCategoryAncestorId,
  BVCommentFilterValueCommentContentLocale,
  BVCommentFilterValueCommentIsFeatured,
  BVCommentFilterValueCommentLastModeratedTime,
  BVCommentFilterValueCommentLastModificationTime,
  BVCommentFilterValueCommentModeratorCode,
  BVCommentFilterValueCommentProductId,
  BVCommentFilterValueCommentReviewId,
  BVCommentFilterValueCommentSubmissionId,
  BVCommentFilterValueCommentSubmissionTime,
  BVCommentFilterValueCommentTotalFeedbackCount,
  BVCommentFilterValueCommentTotalNegativeFeedbackCount,
  BVCommentFilterValueCommentTotalPositiveFeedbackCount,
  BVCommentFilterValueCommentUserLocation
};

#endif /* BVCOMMENTFILTERVALUE_H */
