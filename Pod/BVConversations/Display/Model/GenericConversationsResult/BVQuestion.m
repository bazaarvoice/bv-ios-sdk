//
//  BVQuestion.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestion.h"
#import "BVModelUtil.h"
#import "BVConversationsInclude.h"
#import "BVNullHelper.h"

@implementation BVQuestion

-(id)initWithApiResponse:(NSDictionary *)apiResponse includes:(BVConversationsInclude *)includes {
    self = [super init];
    if(self) {
        
        NSArray<NSString*>* answerIds = apiResponse[@"AnswerIds"];
        NSMutableArray<BVAnswer*>* tempAnswers = [NSMutableArray array];
        
        if (includes){
            for(NSString* answerId in answerIds) {
                BVAnswer* answer = [includes getAnswerById:answerId];
                [tempAnswers addObject:answer];
            }
        }
        
        self.answers = tempAnswers;
        
        SET_IF_NOT_NULL(self.questionSummary, apiResponse[@"QuestionSummary"])
        SET_IF_NOT_NULL(self.totalAnswerCount, apiResponse[@"TotalAnswerCount"])
        SET_IF_NOT_NULL(self.questionDetails, apiResponse[@"QuestionDetails"])
        SET_IF_NOT_NULL(self.totalAnswerCount, apiResponse[@"TotalAnswerCount"])
        SET_IF_NOT_NULL(self.userNickname, apiResponse[@"UserNickname"])
        SET_IF_NOT_NULL(self.categoryId, apiResponse[@"CategoryId"])
        SET_IF_NOT_NULL(self.submissionId, apiResponse[@"SubmissionId"])
        SET_IF_NOT_NULL(self.totalFeedbackCount, apiResponse[@"TotalFeedbackCount"])
        SET_IF_NOT_NULL(self.totalPositiveFeedbackCount, apiResponse[@"TotalPositiveFeedbackCount"])
        SET_IF_NOT_NULL(self.totalInappropriateFeedbackCount, apiResponse[@"TotalInappropriateFeedbackCount"])
        SET_IF_NOT_NULL(self.userLocation, apiResponse[@"UserLocation"])
        SET_IF_NOT_NULL(self.authorId, apiResponse[@"AuthorId"])
        
        NSNumber* featured = apiResponse[@"IsFeatured"];
        if(![featured isKindOfClass:[NSNull class]]) {
            self.isFeatured = [featured boolValue];
        }

        NSNumber* isSyndicated = apiResponse[@"IsSyndicated"];
        if(![isSyndicated isKindOfClass:[NSNull class]]) {
            _isSyndicated = [isSyndicated boolValue];
            
            if (self.isSyndicated) {
                _syndicationSource = [[BVSyndicationSource alloc] initWithApiResponse:apiResponse];
            }
        }

        SET_IF_NOT_NULL(self.productRecommendationIds, apiResponse[@"ProductRecommendationIds"])
        SET_IF_NOT_NULL(self.productId, apiResponse[@"ProductId"])
        SET_IF_NOT_NULL(self.additionalFields, apiResponse[@"AdditionalFields"])
        SET_IF_NOT_NULL(self.campaignId, apiResponse[@"CampaignId"])
        SET_IF_NOT_NULL(self.totalNegativeFeedbackCount, apiResponse[@"TotalNegativeFeedbackCount"])
        SET_IF_NOT_NULL(self.contentLocale, apiResponse[@"ContentLocale"])
        SET_IF_NOT_NULL(self.moderationStatus, apiResponse[@"ModerationStatus"])
        SET_IF_NOT_NULL(self.identifier, apiResponse[@"Id"])

        self.lastModificationTime = [BVModelUtil convertTimestampToDatetime:apiResponse[@"LastModificationTime"]];
        self.submissionTime = [BVModelUtil convertTimestampToDatetime:apiResponse[@"SubmissionTime"]];
        self.lastModeratedTime = [BVModelUtil convertTimestampToDatetime:apiResponse[@"LastModeratedTime"]];

        self.tagDimensions = [BVModelUtil parseTagDimension:apiResponse[@"TagDimensions"]];
        self.photos = [BVModelUtil parsePhotos:apiResponse[@"Photos"]];
        self.videos = [BVModelUtil parseVideos:apiResponse[@"Videos"]];
        self.contextDataValues = [BVModelUtil parseContextDataValues:apiResponse[@"ContextDataValues"]];
        self.badges = [BVModelUtil parseBadges:apiResponse[@"Badges"]];
    }
    return self;
}

@end
