//
//  BVSDK.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for BVSDK.
FOUNDATION_EXPORT double BVSDKVersionNumber;

//! Project version string for BVSDK.
FOUNDATION_EXPORT const unsigned char BVSDKVersionString[];

// In this header, you should import all the public headers of your framework
// using statements like #import <BVSDK/PublicHeader.h>

// Common
#import "BVCommon.h"

// Notifications
#import "BVNotificationCenterObject.h"
#import "BVNotificationConfiguration.h"
#import "BVNotificationConstants.h"
#import "BVNotificationProperties.h"
#import "BVNotificationViewController.h"
#import "BVNotifications.h"
#import "BVNotificationsAnalyticsHelper.h"
#import "BVOpenUrlMetaData.h"
#import "BVProductReviewNotificationCenter.h"
#import "BVProductReviewNotificationConfigurationLoader.h"
#import "BVProductReviewRichNotificationCenter.h"
#import "BVProductReviewSimpleNotificationCenter.h"
#import "BVStoreNotificationConfigurationLoader.h"
#import "BVStoreReviewNotificationCenter.h"
#import "BVStoreReviewNotificationProperties.h"
#import "BVStoreReviewRichNotificationCenter.h"
#import "BVStoreReviewSimpleNotificationCenter.h"

// Analytics
#import "BVAnalyticEventManager.h"
#import "BVBaseAnalyticsHelper.h"

// Conversations
#import "BVAnswersSortOptionValue.h"
#import "BVAuthorIncludeTypeValue.h"
#import "BVBulkRatingFilterValue.h"
#import "BVBulkRatingIncludeTypeValue.h"
#import "BVCommentFilterValue.h"
#import "BVCommentIncludeTypeValue.h"
#import "BVCommentsSortOptionValue.h"
#import "BVConversationDisplay.h"
#import "BVConversations.h"
#import "BVFilterOperatorValues.h"
#import "BVFilterTypeValues.h"
#import "BVIncludeTypeValues.h"
#import "BVMonotonicSortOrderValue.h"
#import "BVProductFilterValue.h"
#import "BVProductIncludeTypeValue.h"
#import "BVProductsSortOptionValue.h"
#import "BVQuestionFilterValue.h"
#import "BVQuestionsSortOptionValue.h"
#import "BVReviewFilterValue.h"
#import "BVReviewIncludeTypeValue.h"
#import "BVReviewsSortOptionValue.h"
#import "BVSortOptionValues.h"
#import "BVSortOrderValues.h"
#import "BVStoreIncludeTypeValue.h"
#import "BVSubmissionResponse.h"

#import "BVAnswer.h"
#import "BVAuthor.h"
#import "BVBadge.h"
#import "BVComment.h"
#import "BVContextDataValue.h"
#import "BVDisplayErrorResponse.h"
#import "BVFormField.h"
#import "BVFormFieldOptions.h"
#import "BVGenericConversationsResult.h"
#import "BVPhoto.h"
#import "BVProduct.h"
#import "BVQuestion.h"
#import "BVReview.h"
#import "BVSecondaryRating.h"
#import "BVSubmissionErrorResponse.h"
#import "BVSyndicationSource.h"
#import "BVVideo.h"

#import "BVErrorCode.h"
#import "BVFormField.h"
#import "BVFormFieldOptions.h"
#import "NSError+BVErrorCodeParser.h"
#import "NSError+BVSubmissionErrorCodeParser.h"

#import "BVAnswer.h"
#import "BVAnswerCollectionViewCell.h"
#import "BVAnswerSubmission.h"
#import "BVAnswerSubmissionErrorResponse.h"
#import "BVAnswerSubmissionResponse.h"
#import "BVAnswerTableViewCell.h"
#import "BVAnswerView.h"
#import "BVAnswersCollectionView.h"
#import "BVAnswersTableView.h"
#import "BVConversationsRequest.h"
#import "BVUploadableStorePhoto.h"

#import "BVBulkRatingsRequest.h"
#import "BVBulkStoreItemsRequest.h"
#import "BVProductDisplayPageRequest.h"
#import "BVProductPageViews.h"
#import "BVQuestionCollectionViewCell.h"
#import "BVQuestionTableViewCell.h"
#import "BVQuestionView.h"
#import "BVQuestionsAndAnswersRequest.h"
#import "BVQuestionsCollectionView.h"
#import "BVQuestionsTableView.h"
#import "BVReviewCollectionViewCell.h"
#import "BVStoreReviewsRequest.h"

#import "BVAuthorRequest.h"
#import "BVBaseProductRequest.h"
#import "BVBaseReviewsRequest.h"
#import "BVBulkProductRequest.h"
#import "BVProductTextSearchRequest.h"
#import "BVReviewSubmissionErrorResponse.h"
#import "BVReviewTableViewCell.h"
#import "BVReviewView.h"
#import "BVReviewsCollectionView.h"
#import "BVReviewsRequest.h"
#import "BVReviewsTableView.h"
#import "BVFeaturesRequest.h"

#import "BVFeedbackSubmission.h"
#import "BVFeedbackSubmissionResponse.h"

/// Dreamcatcher
#import "BVInitiateSubmitRequest.h"
#import "BVInitiateSubmitFormData.h"
#import "BVInitiateSubmitResponse.h"
#import "BVInitiateSubmitErrorResponse.h"
#import "BVInitiateSubmitResponseData.h"

#import "BVProgressiveSubmitRequest.h"
#import "BVProgressiveSubmissionReview.h"
#import "BVProgressiveSubmitResponse.h"
#import "BVProgressiveSubmitErrorResponse.h"
#import "BVProgressiveSubmitResponseData.h"

/// Review Highlights
#import "BVReviewHighlightsRequest.h"
#import "BVReviewHighlightsResponse.h"
#import "BVReviewHighlightsErrorResponse.h"
#import "BVReviewHighlights.h"
#import "BVReviewHighlight.h"
#import "BVReviewHighlightsReview.h"

/// Photo Submission
#import "BVPhotoSubmission.h"
#import "BVPhotoSubmissionErrorResponse.h"
#import "BVPhotoSubmissionResponse.h"

/// Video Submission
#import "BVVideoSubmission.h"
#import "BVVideoSubmissionErrorResponse.h"
#import "BVVideoSubmissionResponse.h"
#import "BVSubmittedVideo.h"

// Question Submission
#import "BVQuestionSubmission.h"
#import "BVQuestionSubmissionErrorResponse.h"
#import "BVQuestionSubmissionResponse.h"
#import "BVSubmittedQuestion.h"

#import "BVSubmittedPhoto.h"

#import "BVStoreReviewSubmission.h"
#import "BVStoreReviewsTableView.h"

#import "BVCommentSubmission.h"
#import "BVCommentSubmissionErrorResponse.h"
#import "BVCommentSubmissionResponse.h"
#import "BVCommentsRequest.h"
#import "BVCommentsResponse.h"
#import "BVSubmittedComment.h"

// Conversations Auth
#import "BVSubmittedUAS.h"
#import "BVUASSubmission.h"
#import "BVUASSubmissionErrorResponse.h"
#import "BVUASSubmissionResponse.h"

// Curations
#import "BVCurations.h"
#import "BVCurationsFeedItem.h"
#import "BVCurationsFeedLoader.h"
#import "BVCurationsFeedRequest.h"

// CurationsUI
#import "BVCurationsUICollectionView.h"
#import "BVCurationsUICollectionViewCell.h"

// Recommendations
#import "BVRecommendations.h"
