//
//  BVSortOptionsComments.h
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The allowable sort types for `BVCommentsRequest` requests.
 API Reference:
 https://developer.bazaarvoice.com/conversations-api/reference/v5.4/comments/comment-display#sort-options
 */
typedef NS_ENUM(NSInteger, BVSortOptionComments) {
  BVSortOptionCommentId,
  BVSortOptionCommentAuthorId,
  BVSortOptionCommentCampaignId,
  BVSortOptionCommentContentLocale,
  BVSortOptionCommentsIsFeatured,
  BVSortOptionCommentsLastModeratedTime,
  BVSortOptionCommentsLastModificationTime,
  BVSortOptionCommentsProductId,
  BVSortOptionCommentsReviewId,
  BVSortOptionCommentsSubmissionId,
  BVSortOptionCommentsSubmissionTime,
  BVSortOptionCommentsTotalFeedbackCount,
  BVSortOptionCommentsTotalNegativeFeedbackCount,
  BVSortOptionCommentsTotalPositiveFeedbackCount,
  BVSortOptionCommentsUserLocation
};

@interface BVSortOptionsCommentUtil : NSObject

+ (nonnull NSString *)toString:(BVSortOptionComments)commentSortOption;

@end
