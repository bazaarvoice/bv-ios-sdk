//
//  BVQuestionFilterType.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionFilterType.h"

@implementation BVQuestionFilterTypeUtil

+(NSString* _Nonnull)toString:(BVQuestionFilterType)filterOperator {
    
    switch (filterOperator) {
            
        case BVQuestionFilterTypeId: return @"Id";
        case BVQuestionFilterTypeAuthorId: return @"AuthorId";
        case BVQuestionFilterTypeCampaignId: return @"CampaignId";
        case BVQuestionFilterTypeCategoryAncestorId: return @"CategoryAncestorId";
        case BVQuestionFilterTypeCategoryId: return @"CategoryId";
        case BVQuestionFilterTypeContentLocale: return @"ContentLocale";
        case BVQuestionFilterTypeHasAnswers: return @"HasAnswers";
        case BVQuestionFilterTypeHasBestAnswer: return @"HasBestAnswer";
        case BVQuestionFilterTypeHasBrandAnswers: return @"HasBrandAnswers";
        case BVQuestionFilterTypeHasPhotos: return @"HasPhotos";
        case BVQuestionFilterTypeHasStaffAnswers: return @"HasStaffAnswers";
        case BVQuestionFilterTypeHasTags: return @"HasTags";
        case BVQuestionFilterTypeHasVideos: return @"HasVideos";
        case BVQuestionFilterTypeIsFeatured: return @"IsFeatured";
        case BVQuestionFilterTypeIsSubjectActive: return @"IsSubjectActive";
        case BVQuestionFilterTypeLastApprovedAnswerSubmissionTime: return @"LastApprovedAnswerSubmissionTime";
        case BVQuestionFilterTypeLastModeratedTime: return @"LastModeratedTime";
        case BVQuestionFilterTypeLastModificationTime: return @"LastModificationTime";
        case BVQuestionFilterTypeModeratorCode: return @"ModeratorCode";
        case BVQuestionFilterTypeSubmissionId: return @"SubmissionId";
        case BVQuestionFilterTypeSubmissionTime: return @"SubmissionTime";
        case BVQuestionFilterTypeSummary: return @"Summary";
        case BVQuestionFilterTypeTotalAnswerCount: return @"TotalAnswerCount";
        case BVQuestionFilterTypeTotalFeedbackCount: return @"TotalFeedbackCount";
        case BVQuestionFilterTypeTotalNegativeFeedbackCount: return @"TotalNegativeFeedbackCount";
        case BVQuestionFilterTypeTotalPositiveFeedbackCount: return @"TotalPositiveFeedbackCount";
        case BVQuestionFilterTypeUserLocation: return @"UserLocation";
            
    }
    
}


@end
