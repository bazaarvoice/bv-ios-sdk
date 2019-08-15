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
#import <BVSDK/BVCommon.h>

// Notifications
#import <BVSDK/BVNotificationCenterObject.h>
#import <BVSDK/BVNotificationConfiguration.h>
#import <BVSDK/BVNotificationConstants.h>
#import <BVSDK/BVNotificationProperties.h>
#import <BVSDK/BVNotificationViewController.h>
#import <BVSDK/BVNotifications.h>
#import <BVSDK/BVNotificationsAnalyticsHelper.h>
#import <BVSDK/BVOpenUrlMetaData.h>
#import <BVSDK/BVProductReviewNotificationCenter.h>
#import <BVSDK/BVProductReviewNotificationConfigurationLoader.h>
#import <BVSDK/BVProductReviewRichNotificationCenter.h>
#import <BVSDK/BVProductReviewSimpleNotificationCenter.h>
#import <BVSDK/BVStoreNotificationConfigurationLoader.h>
#import <BVSDK/BVStoreReviewNotificationCenter.h>
#import <BVSDK/BVStoreReviewNotificationProperties.h>
#import <BVSDK/BVStoreReviewRichNotificationCenter.h>
#import <BVSDK/BVStoreReviewSimpleNotificationCenter.h>

// Analytics
#import <BVSDK/BVAnalyticEventManager.h>
#import <BVSDK/BVBaseAnalyticsHelper.h>

// Conversations
#import <BVSDK/BVAnswersSortOptionValue.h>
#import <BVSDK/BVAuthorIncludeTypeValue.h>
#import <BVSDK/BVBulkRatingFilterValue.h>
#import <BVSDK/BVBulkRatingIncludeTypeValue.h>
#import <BVSDK/BVCommentFilterValue.h>
#import <BVSDK/BVCommentIncludeTypeValue.h>
#import <BVSDK/BVCommentsSortOptionValue.h>
#import <BVSDK/BVConversationDisplay.h>
#import <BVSDK/BVConversations.h>
#import <BVSDK/BVFilterOperatorValues.h>
#import <BVSDK/BVFilterTypeValues.h>
#import <BVSDK/BVIncludeTypeValues.h>
#import <BVSDK/BVMonotonicSortOrderValue.h>
#import <BVSDK/BVProductFilterValue.h>
#import <BVSDK/BVProductIncludeTypeValue.h>
#import <BVSDK/BVProductsSortOptionValue.h>
#import <BVSDK/BVQuestionFilterValue.h>
#import <BVSDK/BVQuestionsSortOptionValue.h>
#import <BVSDK/BVReviewFilterValue.h>
#import <BVSDK/BVReviewIncludeTypeValue.h>
#import <BVSDK/BVReviewsSortOptionValue.h>
#import <BVSDK/BVSortOptionValues.h>
#import <BVSDK/BVSortOrderValues.h>
#import <BVSDK/BVStoreIncludeTypeValue.h>
#import <BVSDK/BVSubmissionResponse.h>

#import <BVSDK/BVAnswer.h>
#import <BVSDK/BVAuthor.h>
#import <BVSDK/BVBadge.h>
#import <BVSDK/BVComment.h>
#import <BVSDK/BVContextDataValue.h>
#import <BVSDK/BVDisplayErrorResponse.h>
#import <BVSDK/BVFormField.h>
#import <BVSDK/BVFormFieldOptions.h>
#import <BVSDK/BVGenericConversationsResult.h>
#import <BVSDK/BVPhoto.h>
#import <BVSDK/BVProduct.h>
#import <BVSDK/BVQuestion.h>
#import <BVSDK/BVReview.h>
#import <BVSDK/BVSecondaryRating.h>
#import <BVSDK/BVSubmissionErrorResponse.h>
#import <BVSDK/BVSyndicationSource.h>
#import <BVSDK/BVVideo.h>

#import <BVSDK/BVErrorCode.h>
#import <BVSDK/BVFormField.h>
#import <BVSDK/BVFormFieldOptions.h>
#import <BVSDK/NSError+BVErrorCodeParser.h>
#import <BVSDK/NSError+BVSubmissionErrorCodeParser.h>

#import <BVSDK/BVAnswer.h>
#import <BVSDK/BVAnswerCollectionViewCell.h>
#import <BVSDK/BVAnswerSubmission.h>
#import <BVSDK/BVAnswerSubmissionErrorResponse.h>
#import <BVSDK/BVAnswerSubmissionResponse.h>
#import <BVSDK/BVAnswerTableViewCell.h>
#import <BVSDK/BVAnswerView.h>
#import <BVSDK/BVAnswersCollectionView.h>
#import <BVSDK/BVAnswersTableView.h>
#import <BVSDK/BVConversationsRequest.h>
#import <BVSDK/BVUploadableStorePhoto.h>

#import <BVSDK/BVBulkRatingsRequest.h>
#import <BVSDK/BVBulkStoreItemsRequest.h>
#import <BVSDK/BVProductDisplayPageRequest.h>
#import <BVSDK/BVProductPageViews.h>
#import <BVSDK/BVQuestionCollectionViewCell.h>
#import <BVSDK/BVQuestionTableViewCell.h>
#import <BVSDK/BVQuestionView.h>
#import <BVSDK/BVQuestionsAndAnswersRequest.h>
#import <BVSDK/BVQuestionsCollectionView.h>
#import <BVSDK/BVQuestionsTableView.h>
#import <BVSDK/BVReviewCollectionViewCell.h>
#import <BVSDK/BVStoreReviewsRequest.h>
#import <BVSDK/BVUploadableYouTubeVideo.h>

#import <BVSDK/BVAuthorRequest.h>
#import <BVSDK/BVBaseProductRequest.h>
#import <BVSDK/BVBaseReviewsRequest.h>
#import <BVSDK/BVBulkProductRequest.h>
#import <BVSDK/BVProductTextSearchRequest.h>
#import <BVSDK/BVReviewSubmissionErrorResponse.h>
#import <BVSDK/BVReviewTableViewCell.h>
#import <BVSDK/BVReviewView.h>
#import <BVSDK/BVReviewsCollectionView.h>
#import <BVSDK/BVReviewsRequest.h>
#import <BVSDK/BVReviewsTableView.h>

#import <BVSDK/BVFeedbackSubmission.h>
#import <BVSDK/BVFeedbackSubmissionResponse.h>

/// Dreamcatcher
#import <BVSDK/BVInitiateSubmitRequest.h>
#import <BVSDK/BVInitiateSubmitFormData.h>
#import <BVSDK/BVInitiateSubmitResponse.h>
#import <BVSDK/BVInitiateSubmitErrorResponse.h>
#import <BVSDK/BVInitiateSubmitResponseData.h>

#import <BVSDK/BVProgressiveSubmitRequest.h>
#import <BVSDK/BVProgressiveSubmissionReview.h>
#import <BVSDK/BVProgressiveSubmitResponse.h>
#import <BVSDK/BVProgressiveSubmitErrorResponse.h>
#import <BVSDK/BVProgressiveSubmitResponseData.h>

/// Photo Submission
#import <BVSDK/BVPhotoSubmission.h>
#import <BVSDK/BVPhotoSubmissionErrorResponse.h>
#import <BVSDK/BVPhotoSubmissionResponse.h>


// Question Submission
#import <BVSDK/BVQuestionSubmission.h>
#import <BVSDK/BVQuestionSubmissionErrorResponse.h>
#import <BVSDK/BVQuestionSubmissionResponse.h>
#import <BVSDK/BVSubmittedQuestion.h>

#import <BVSDK/BVSubmittedPhoto.h>

#import <BVSDK/BVStoreReviewSubmission.h>
#import <BVSDK/BVStoreReviewsTableView.h>

#import <BVSDK/BVCommentSubmission.h>
#import <BVSDK/BVCommentSubmissionErrorResponse.h>
#import <BVSDK/BVCommentSubmissionResponse.h>
#import <BVSDK/BVCommentsRequest.h>
#import <BVSDK/BVCommentsResponse.h>
#import <BVSDK/BVSubmittedComment.h>

// Conversations Auth
#import <BVSDK/BVSubmittedUAS.h>
#import <BVSDK/BVUASSubmission.h>
#import <BVSDK/BVUASSubmissionErrorResponse.h>
#import <BVSDK/BVUASSubmissionResponse.h>

// Curations
#import <BVSDK/BVCurations.h>
#import <BVSDK/BVCurationsFeedItem.h>
#import <BVSDK/BVCurationsFeedLoader.h>
#import <BVSDK/BVCurationsFeedRequest.h>

// CurationsUI
#import <BVSDK/BVCurationsUICollectionView.h>
#import <BVSDK/BVCurationsUICollectionViewCell.h>

// Recommendations
#import <BVSDK/BVRecommendations.h>
