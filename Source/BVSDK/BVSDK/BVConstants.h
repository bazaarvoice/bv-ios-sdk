//
//  BVConstants.h
//  BazaarvoiceSDK
//
//  All enumerated constants, used throughought the SDK to specify
//  request parameters
//
//  Created by Bazaarvoice Engineering on 11/26/12.
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
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

// type for BVPost
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
    BVMediaPostContentTypeReviewComment,
    BVMediaPostContentTypeQuestion,
    BVMediaPostContentTypeAnswer,
    BVMediaPostContentTypeStory,
    BVMediaPostContentTypeStoryComment
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
