//
//  BVReviewFilterType.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewFilterType.h"

@implementation BVReviewFilterTypeUtil

+ (nonnull NSString *)toString:(BVReviewFilterType)filterOperator {

  switch (filterOperator) {

  case BVReviewFilterTypeId:
    return @"Id";
  case BVReviewFilterTypeAuthorId:
    return @"AuthorId";
  case BVReviewFilterTypeCampaignId:
    return @"CampaignId";
  case BVReviewFilterTypeCategoryAncestorId:
    return @"CategoryAncestorId";
  case BVReviewFilterTypeContentLocale:
    return @"ContentLocale";
  case BVReviewFilterTypeHasComments:
    return @"HasComments";
  case BVReviewFilterTypeHasPhotos:
    return @"HasPhotos";
  case BVReviewFilterTypeHasTags:
    return @"HasTags";
  case BVReviewFilterTypeHasVideos:
    return @"HasVideos";
  case BVReviewFilterTypeIsFeatured:
    return @"IsFeatured";
  case BVReviewFilterTypeIsRatingsOnly:
    return @"IsRatingsOnly";
  case BVReviewFilterTypeIsRecommended:
    return @"IsRecommended";
  case BVReviewFilterTypeIsSubjectActive:
    return @"IsSubjectActive";
  case BVReviewFilterTypeIsSyndicated:
    return @"IsSyndicated";
  case BVReviewFilterTypeLastModeratedTime:
    return @"LastModeratedTime";
  case BVReviewFilterTypeLastModificationTime:
    return @"LastModificationTime";
  case BVReviewFilterTypeModeratorCode:
    return @"ModeratorCode";
  case BVReviewFilterTypeRating:
    return @"Rating";
  case BVReviewFilterTypeSubmissionId:
    return @"SubmissionId";
  case BVReviewFilterTypeSubmissionTime:
    return @"SubmissionTime";
  case BVReviewFilterTypeTotalCommentCount:
    return @"TotalCommentCount";
  case BVReviewFilterTypeTotalFeedbackCount:
    return @"TotalFeedbackCount";
  case BVReviewFilterTypeTotalNegativeFeedbackCount:
    return @"TotalNegativeFeedbackCount";
  case BVReviewFilterTypeTotalPositiveFeedbackCount:
    return @"TotalPositiveFeedbackCount";
  case BVReviewFilterTypeUserLocation:
    return @"UserLocation";
  }
}

@end
