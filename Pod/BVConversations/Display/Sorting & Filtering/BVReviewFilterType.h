//
//  BVReviewFilterType.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The allowable filter types for `BVReviewsRequest` requests.
 */
typedef NS_ENUM(NSInteger, BVReviewFilterType) {
    BVReviewFilterTypeId,
    BVReviewFilterTypeAuthorId,
    BVReviewFilterTypeCampaignId,
    BVReviewFilterTypeCategoryAncestorId,
    BVReviewFilterTypeContentLocale,
    BVReviewFilterTypeHasComments,
    BVReviewFilterTypeHasPhotos,
    BVReviewFilterTypeHasTags,
    BVReviewFilterTypeHasVideos,
    BVReviewFilterTypeIsFeatured,
    BVReviewFilterTypeIsRatingsOnly,
    BVReviewFilterTypeIsRecommended,
    BVReviewFilterTypeIsSubjectActive,
    BVReviewFilterTypeIsSyndicated,
    BVReviewFilterTypeLastModeratedTime,
    BVReviewFilterTypeLastModificationTime,
    BVReviewFilterTypeModeratorCode,
    BVReviewFilterTypeRating,
    BVReviewFilterTypeSubmissionId,
    BVReviewFilterTypeSubmissionTime,
    BVReviewFilterTypeTotalCommentCount,
    BVReviewFilterTypeTotalFeedbackCount,
    BVReviewFilterTypeTotalNegativeFeedbackCount,
    BVReviewFilterTypeTotalPositiveFeedbackCount,
    BVReviewFilterTypeUserLocation
};

@interface BVReviewFilterTypeUtil : NSObject

+(NSString* _Nonnull)toString:(BVReviewFilterType)filterOperator;

@end
