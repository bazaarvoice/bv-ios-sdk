//
//  BVCommentFilterType.h
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The allowable filter types for `BVCommentsRequest` requests.
 API Refernce: https://developer.bazaarvoice.com/conversations-api/reference/v5.4/comments/comment-display#filter-options
 */
typedef NS_ENUM(NSInteger, BVCommentFilterType) {
    BVCommentFilterTypeId,
    BVCommentFilterTypeAuthorId,
    BVCommentFilterTypeCampaignId,
    BVCommentFilterTypeCategoryAncestorId,
    BVCommentFilterTypeContentLocale,
    BVCommentFilterTypeIsFeatured,
    BVCommentFilterTypeLastModeratedTime,
    BVCommentFilterTypeLastModificationTime,
    BVCommentFilterTypeModeratorCode,
    BVCommentFilterTypeProductId,
    BVCommentFilterTypeReviewId,
    BVCommentFilterTypeSubmissionId,
    BVCommentFilterTypeSubmissionTime,
    BVCommentFilterTypeTotalFeedbackCount,
    BVCommentFilterTypeTotalNegativeFeedbackCount,
    BVCommentFilterTypeTotalPositiveFeedbackCount,
    BVCommentFilterTypeUserLocation
};


@interface BVCommentFilterTypeUtil : NSObject

+(NSString* _Nonnull)toString:(BVCommentFilterType)commentFilterOperator;

@end
