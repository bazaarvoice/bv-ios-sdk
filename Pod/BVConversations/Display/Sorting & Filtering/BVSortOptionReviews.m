//
//  BVSortOptionReviews.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSortOptionReviews.h"

@implementation BVSortOptionReviewUtil

+ (nonnull NSString *)toString:(BVSortOptionReviews)BVSortOptionReviews {

  switch (BVSortOptionReviews) {

  case BVSortOptionReviewsId:
    return @"Id";
  case BVSortOptionReviewsAuthorId:
    return @"AuthorId";
  case BVSortOptionReviewsCampaignId:
    return @"CampaignId";
  case BVSortOptionReviewsContentLocale:
    return @"ContentLocale";
  case BVSortOptionReviewsHasComments:
    return @"HasComments";
  case BVSortOptionReviewsHasPhotos:
    return @"HasPhotos";
  case BVSortOptionReviewsHasTags:
    return @"HasTags";
  case BVSortOptionReviewsHasVideos:
    return @"HasVideos";
  case BVSortOptionReviewsHelpfulness:
    return @"Helpfulness";
  case BVSortOptionReviewsIsFeatured:
    return @"IsFeatured";
  case BVSortOptionReviewsIsRatingsOnly:
    return @"IsRatingsOnly";
  case BVSortOptionReviewsIsRecommended:
    return @"IsRecommended";
  case BVSortOptionReviewsIsSubjectActive:
    return @"IsSubjectActive";
  case BVSortOptionReviewsIsSyndicated:
    return @"IsSyndicated";
  case BVSortOptionReviewsLastModeratedTime:
    return @"LastModeratedTime";
  case BVSortOptionReviewsLastModificationTime:
    return @"LastModificationTime";
  case BVSortOptionReviewsProductId:
    return @"ProductId";
  case BVSortOptionReviewsRating:
    return @"Rating";
  case BVSortOptionReviewsSubmissionId:
    return @"SubmissionId";
  case BVSortOptionReviewsSubmissionTime:
    return @"SubmissionTime";
  case BVSortOptionReviewsTotalCommentCount:
    return @"TotalCommentCount";
  case BVSortOptionReviewsTotalFeedbackCount:
    return @"TotalFeedbackCount";
  case BVSortOptionReviewsTotalNegativeFeedbackCount:
    return @"TotalNegativeFeedbackCount";
  case BVSortOptionReviewsTotalPositiveFeedbackCount:
    return @"TotalPositiveFeedbackCount";
  case BVSortOptionReviewsUserLocation:
    return @"UserLocation";
  }
}

@end
