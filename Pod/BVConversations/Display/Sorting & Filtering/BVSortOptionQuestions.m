//
//  BVSortOptionQuestions.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSortOptionQuestions.h"

@implementation BVSortOptionQuestionsUtil

+(NSString* _Nonnull)toString:(BVSortOptionQuestions)BVSortOptionQuestions {
    
    switch (BVSortOptionQuestions) {
            
        case BVSortOptionQuestionsId: return @"Id";
        case BVSortOptionQuestionsAuthorId: return @"AuthorId";
        case BVSortOptionQuestionsCampaignId: return @"CampaignId";
        case BVSortOptionQuestionsContentLocale: return @"ContentLocale";
        case BVSortOptionQuestionsHasAnswers: return @"HasAnswers";
        case BVSortOptionQuestionsHasBestAnswer: return @"HasBestAnswer";
        case BVSortOptionQuestionsHasPhotos: return @"HasPhotos";
        case BVSortOptionQuestionsHasStaffAnswers: return @"HasStaffAnswers";
        case BVSortOptionQuestionsHasVideos: return @"HasVideos";
        case BVSortOptionQuestionsIsFeatured: return @"IsFeatured";
        case BVSortOptionQuestionsIsSubjectActive: return @"IsSubjectActive";
        case BVSortOptionQuestionsLastApprovedAnswerSubmissionTime: return @"LastApprovedAnswerSubmissionTime";
        case BVSortOptionQuestionsLastModeratedTime: return @"LastModeratedTime";
        case BVSortOptionQuestionsLastModificationTime: return @"LastModificationTime";
        case BVSortOptionQuestionsProductId: return @"ProductId";
        case BVSortOptionQuestionsSubmissionId: return @"SubmissionId";
        case BVSortOptionQuestionsSubmissionTime: return @"SubmissionTime";
        case BVSortOptionQuestionsSummary: return @"Summary";
        case BVSortOptionQuestionsTotalAnswerCount: return @"TotalAnswerCount";
        case BVSortOptionQuestionsTotalFeedbackCount: return @"TotalFeedbackCount";
        case BVSortOptionQuestionsTotalNegativeFeedbackCount: return @"TotalNegativeFeedbackCount";
        case BVSortOptionQuestionsTotalPositiveFeedbackCount: return @"TotalPositiveFeedbackCount";
        case BVSortOptionQuestionsUserLocation: return @"UserLocation";
            
    }
    
}


@end
