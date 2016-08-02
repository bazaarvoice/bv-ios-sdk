//
//  QAStatistics.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQAStatistics.h"
#import "BVDimensionAndDistributionUtil.h"
#import "BVModelUtil.h"
#import "BVNullHelper.h"

@implementation BVQAStatistics

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse {
    
    self = [super init];
    if(self){
        if (apiResponse == nil){
            return nil;
        }
        
        NSDictionary* apiObject = apiResponse;
        
        SET_IF_NOT_NULL(self.helpfulVoteCount, apiObject[@"HelpfulVoteCount"])
        SET_IF_NOT_NULL(self.bestAnswerCount, apiObject[@"BestAnswerCount"])
        SET_IF_NOT_NULL(self.questionHelpfulVoteCount, apiObject[@"QuestionHelpfulVoteCount"])
        SET_IF_NOT_NULL(self.totalAnswerCount, apiObject[@"TotalAnswerCount"])
        SET_IF_NOT_NULL(self.answerNotHelpfulVoteCount, apiObject[@"AnswerNotHelpfulVoteCount"])
        SET_IF_NOT_NULL(self.totalQuestionCount, apiObject[@"TotalQuestionCount"])
        SET_IF_NOT_NULL(self.questionNotHelpfulVoteCount, apiObject[@"QuestionNotHelpfulVoteCount"])
        SET_IF_NOT_NULL(self.featuredQuestionCount, apiObject[@"FeaturedQuestionCount"])
        SET_IF_NOT_NULL(self.featuredAnswerCount, apiObject[@"FeaturedAnswerCount"])
        SET_IF_NOT_NULL(self.answerHelpfulVoteCount, apiObject[@"AnswerHelpfulVoteCount"])
        
        self.tagDistribution = [BVDimensionAndDistributionUtil createDistributionWithApiResponse:apiObject[@"TagDistribution"]];
        self.contextDataDistribution = [BVDimensionAndDistributionUtil createDistributionWithApiResponse:apiObject[@"ContextDataDistribution"]];
        self.firstQuestionTime = [BVModelUtil convertTimestampToDatetime:apiObject[@"FirstQuestionTime"]];
        self.lastQuestionTime = [BVModelUtil convertTimestampToDatetime:apiObject[@"LastQuestionTime"]];
        self.firstAnswerTime = [BVModelUtil convertTimestampToDatetime:apiObject[@"FirstAnswerTime"]];
        self.lastAnswerTime = [BVModelUtil convertTimestampToDatetime:apiObject[@"LastAnswerTime"]];
        self.lastQuestionAnswerTime = [BVModelUtil convertTimestampToDatetime:apiObject[@"LastQuestionAnswerTime"]];

    }
    return self;
    
}

@end
