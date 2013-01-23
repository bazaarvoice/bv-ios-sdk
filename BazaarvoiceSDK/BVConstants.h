//
//  BVConstants.h
//  BazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 11/26/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#ifndef BazaarvoiceSDK_BVConstants_h
#define BazaarvoiceSDK_BVConstants_h

// type for BVGet
typedef enum {
    BVGetTypeAnswers,
    BVGetTypeAuthors,
    BVGetTypeCategories,
    BVGetTypeReviewCommments,
    BVGetTypeStoryCommments,
    BVGetTypeProducts,
    BVGetTypeQuestions,
    BVGetTypeReviews,
    BVGetTypeStatistics,
    BVGetTypeStories
} BVGetType;

// type for BVPost=
typedef enum {
    BVPostTypeAnswer,
    BVPostTypeReviewComment,
    BVPostTypeStoryComment,
    BVPostTypeFeedback,
    BVPostTypeQuestion,
    BVPostTypeReview,
    BVPostTypeStory,
} BVPostType;

// type for BVMediaPost
typedef enum {
    BVMediaPostTypePhoto,
    BVMediaPostTypeVideo
}BVMediaPostType;

// contentType for BVMediaPost
typedef enum {
    BVMediaPostContentTypeReview,
    BVMediaPostContentTypeQuestion,
    BVMediaPostContentTypeAnswer,
    BVMediaPostContentTypeStory
} BVMediaPostContentType;

// equality for BVGet filters
typedef enum {
    BVEqualityGreaterThan,
    BVEqualityGreaterThanOrEqual,
    BVEqualityLessThan,
    BVEqualityLessThanOrEqual,
    BVEqualityEqualTo,
    BVEqualityNotEqualTo
} BVEquality;

// action for BVPost
typedef enum {
    BVActionPreview,
    BVActionSubmit
} BVAction;

// feedbackType for BVPost with BVPostTypeFeedback
typedef enum {
    BVFeedbackTypeInappropriate,
    BVFeedbackTypeHelpfulness
} BVFeedbackType;

// vote for BVPost with BVPostTypeFeedback
typedef enum {
    BVFeedbackVoteTypePositive,
    BVFeedbackVoteTypeNegative
} BVFeedbackVoteType;

// contentType for BVPost with BVPostTypeFeedback
typedef enum {
    BVFeedbackContentTypeAnswer,
    BVFeedbackContentTypeQuestion,
    BVFeedbackContentTypeReview,
    BVFeedbackContentTypeReviewComment,
    BVFeedbackContentTypeStory,
    BVFeedbackContentTypeStoryComment
} BVFeedbackContentType;

// include for BVGet
typedef enum {
    BVIncludeTypeAnswers,
    BVIncludeTypeAuthors,
    BVIncludeTypeCategories,
    BVIncludeTypeComments,
    BVIncludeTypeProducts,
    BVIncludeTypeQuestions,
    BVIncludeTypeReviews,
    BVIncludeTypeStories
} BVIncludeType;

// stats for BVGet
typedef enum {
    BVIncludeStatsTypeReviews,
    BVIncludeStatsTypeNativeReviews,
    BVIncludeStatsTypeQuestions,
    BVIncludeStatsTypeAnswers,
    BVIncludeStatsTypeStories
} BVIncludeStatsType;

// stats for BVGet
typedef enum {
    BVVideoFormatType3GP,
    BVVideoFormatType3G2,
    BVVideoFormatTypeASF,
    BVVideoFormatTypeDV,
    BVVideoFormatTypeFLV,
    BVVideoFormatTypeMOV,
    BVVideoFormatTypeMP4,
    BVVideoFormatTypeF4V,
    BVVideoFormatTypeMPEG,
    BVVideoFormatTypeQT,
    BVVideoFormatTypeWMV
} BVVideoFormatType;

#endif
