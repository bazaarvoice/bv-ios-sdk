//
//  BVSortOptionReviews.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The allowable sort types for `BVReviewsRequest` requests.
 */
typedef NS_ENUM(NSInteger, BVSortOptionReviews) {
  BVSortOptionReviewsId,
  BVSortOptionReviewsAuthorId,
  BVSortOptionReviewsCampaignId,
  BVSortOptionReviewsContentLocale,
  BVSortOptionReviewsHasComments,
  BVSortOptionReviewsHasPhotos,
  BVSortOptionReviewsHasTags,
  BVSortOptionReviewsHasVideos,
  BVSortOptionReviewsHelpfulness,
  BVSortOptionReviewsIsFeatured,
  BVSortOptionReviewsIsRatingsOnly,
  BVSortOptionReviewsIsRecommended,
  BVSortOptionReviewsIsSubjectActive,
  BVSortOptionReviewsIsSyndicated,
  BVSortOptionReviewsLastModeratedTime,
  BVSortOptionReviewsLastModificationTime,
  BVSortOptionReviewsProductId,
  BVSortOptionReviewsRating,
  BVSortOptionReviewsSubmissionId,
  BVSortOptionReviewsSubmissionTime,
  BVSortOptionReviewsTotalCommentCount,
  BVSortOptionReviewsTotalFeedbackCount,
  BVSortOptionReviewsTotalNegativeFeedbackCount,
  BVSortOptionReviewsTotalPositiveFeedbackCount,
  BVSortOptionReviewsUserLocation
};

@interface BVSortOptionReviewUtil : NSObject

+ (nonnull NSString *)toString:(BVSortOptionReviews)BVSortOptionReviews;

@end
