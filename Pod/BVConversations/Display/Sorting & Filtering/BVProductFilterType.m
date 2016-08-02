//
//  BVProductFilterType.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductFilterType.h"

@implementation BVProductFilterTypeUtil

+(NSString* _Nonnull)toString:(BVProductFilterType)filterOperator {
    
    switch (filterOperator) {
            
        case BVProductFilterTypeId: return @"Id";
        case BVProductFilterTypeAverageOverallRating: return @"AverageOverallRating";
        case BVProductFilterTypeCategoryAncestorId: return @"CategoryAncestorId";
        case BVProductFilterTypeCategoryId: return @"CategoryId";
        case BVProductFilterTypeIsActive: return @"IsActive";
        case BVProductFilterTypeIsDisabled: return @"IsDisabled";
        case BVProductFilterTypeLastAnswerTime: return @"LastAnswerTime";
        case BVProductFilterTypeLastQuestionTime: return @"LastQuestionTime";
        case BVProductFilterTypeLastReviewTime: return @"LastReviewTime";
        case BVProductFilterTypeLastStoryTime: return @"LastStoryTime";
        case BVProductFilterTypeName: return @"Name";
        case BVProductFilterTypeRatingsOnlyReviewCount: return @"RatingsOnlyReviewCount";
        case BVProductFilterTypeTotalAnswerCount: return @"TotalAnswerCount";
        case BVProductFilterTypeTotalQuestionCount: return @"TotalQuestionCount";
        case BVProductFilterTypeTotalReviewCount: return @"TotalReviewCount";
        case BVProductFilterTypeTotalStoryCount: return @"TotalStoryCount";
            
    }
    
}

@end
