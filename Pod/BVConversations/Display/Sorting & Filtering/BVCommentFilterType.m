//
//  BVCommentFilterType.m
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentFilterType.h"

@implementation BVCommentFilterTypeUtil

+ (nonnull NSString *)toString:(BVCommentFilterType)commentFilterOperator {

  switch (commentFilterOperator) {
  case BVCommentFilterTypeId:
    return @"Id";
  case BVCommentFilterTypeAuthorId:
    return @"AuthorId";
  case BVCommentFilterTypeCampaignId:
    return @"CampaignId";
  case BVCommentFilterTypeCategoryAncestorId:
    return @"CategoryAncestorId";
  case BVCommentFilterTypeContentLocale:
    return @"ContentLocale";
  case BVCommentFilterTypeIsFeatured:
    return @"IsFeatured";
  case BVCommentFilterTypeLastModeratedTime:
    return @"LastModeratedTime";
  case BVCommentFilterTypeLastModificationTime:
    return @"LastModificationTime";
  case BVCommentFilterTypeModeratorCode:
    return @"ModeratorCode";
  case BVCommentFilterTypeProductId:
    return @"ProductId";
  case BVCommentFilterTypeReviewId:
    return @"ReviewId";
  case BVCommentFilterTypeSubmissionId:
    return @"SubmissionId";
  case BVCommentFilterTypeSubmissionTime:
    return @"SubmissionTime";
  case BVCommentFilterTypeTotalFeedbackCount:
    return @"TotalFeedbackCount";
  case BVCommentFilterTypeTotalNegativeFeedbackCount:
    return @"TotalNegativeFeedbackCount";
  case BVCommentFilterTypeTotalPositiveFeedbackCount:
    return @"TotalPositiveFeedbackCount";
  case BVCommentFilterTypeUserLocation:
    return @"UserLocation";
  }
}

@end
